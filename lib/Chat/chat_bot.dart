import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bytebrahmand_codeshastra/constants/colors.dart';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/foundation.dart' show kIsWeb;

class ChatBotWidget extends StatefulWidget {
  const ChatBotWidget({
    super.key,
  });

  @override
  State<ChatBotWidget> createState() => _ChatBotWidgetState();
}

enum TtsState { playing, stopped, paused, continued }

class _ChatBotWidgetState extends State<ChatBotWidget> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  late String _text;
  late String _filePath;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    focusNode = FocusNode();
    // focusNode.requestFocus();
    super.initState();
  }

  Future<void> _startListening() async {
    if (!_isListening) {
      await _initRecording();
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('Status: $status');
        },
        onError: (error) {
          print('Error: $error');
          _stopRecording();
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
          },
          listenFor: Duration(seconds: 15),
          localeId: 'en_US',
          cancelOnError: true,
          partialResults: true,
        );
      } else {
        setState(() => _isListening = false);
        print('Speech recognition not available');
      }
    }
  }

  Future<void> _stopRecording() async {
    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
        setState(() {
          addChat(_text, false);
        });
      });
    }

    if (_filePath != null) {
      _postAudioFile(_filePath);
    }
  }

  Future<void> _initRecording() async {
    if (!await _hasPermission()) {
      // Handle the case where the user declines the permission request.
      return;
    }

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    _filePath = '${appDocDir.path}/recording_$timestamp.wav';

    // Debugging: Print the file path
    print('File path: $_filePath');

    // Ensure directory exists
    if (!appDocDir.existsSync()) {
      appDocDir.createSync(recursive: true);
    }

    // Create the file
    File file = File(_filePath);
    try {
      if (!file.existsSync()) {
        file.createSync();
        print('File created successfully');
      } else {
        print('File already exists');
      }
    } catch (e) {
      print('Error creating file: $e');
    }
  }

  Future<bool> _hasPermission() async {
    final stt.SpeechToText speech = stt.SpeechToText();
    final status = await speech.initialize();
    return status;
  }

  Future<void> _postAudioFile(String filePath) async {
    print("FILEPATH: $filePath");
    File checkFileType = File(filePath);
    print("FILETYPE: ${checkFileType.path.split('.').last}");
    if (filePath == null) {
      print('File path is null');
      return;
    }

    File file = File(filePath);
    if (!file.existsSync()) {
      print('File does not exist at path: $filePath');
      return;
    }

    Map<String, dynamic> rawBody = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": _text}
          ]
        }
      ]
    };
    var responseRaw = await http.post(
        Uri.parse(
            "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=AIzaSyDZ7q5vFZARCv2nShdqnjqE4K7dh3z23PU"),
        body: jsonEncode(rawBody));
    print("RESPONSE BODY: ${responseRaw.body}");
    String finalAnswer = jsonDecode(responseRaw.body)['candidates'][0]
            ['content']['parts'][0]['text'] ??
        "Sorry, Didn't understand that. Please try again.";
    print("FINAL ANSWER: $finalAnswer");
    setState(() {
      addChat(finalAnswer ?? "Sorry, Didn't understand that. Please try again.",
          true);
    });

    // try {
    //   var request = http.MultipartRequest(
    //     'POST',
    //     Uri.parse('https://codeshastra-bytebrahmand.onrender.com/upload'),
    //   );
    //   request.files
    //       .add(await http.MultipartFile.fromPath('audio_file', filePath));

    //   var response = await request.send();

    //   if (response.statusCode == 200) {
    //     // Decode response body
    //     var jsonResponse = await _decodeResponse(response);
    //     if (jsonResponse != null) {
    //       String audioUrl = jsonResponse['transcription'];
    //       print('Response: $jsonResponse');
    //       setState(() {
    //         _text = audioUrl;
    //       });
    //     }
    //   } else {
    //     print(
    //         'Failed to post audio: ${response.statusCode}  ${response.reasonPhrase}');
    //   }
    // } catch (e) {
    //   print('Error posting audio: $e');
    // }

    // var response = await http
    //     .get(Uri.parse("https://codeshastra-bytebrahmand.onrender.com/"));
    // print("EMPTY API" + response.body);
  }

  Future<Map<String, dynamic>?> _decodeResponse(
      http.StreamedResponse response) async {
    try {
      // Decode response stream
      var decodedResponse = await utf8.decodeStream(response.stream);

      // Parse decoded response
      return jsonDecode(decodedResponse);
    } catch (e) {
      print('Error decoding response: $e');
    }
  }

  bool isTyping = true,
      isBotResponding = false,
      isWaiting = false,
      isLast = false,
      setDate = true;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController scrollController;

  final openAI = OpenAI.instance.build(
    token: "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",
    baseOption: HttpSetup(receiveTimeout: Duration(seconds: 20)),
    enableLog: true,
  );

  List<ChatBotMessages> chats = [
    ChatBotMessages("Hi, how can I help you?", DateTime.now(), true),
  ];

  // @override
  // void initState() {
  //   textEditingController = TextEditingController();
  //   scrollController = ScrollController();
  //   focusNode = FocusNode();
  //   focusNode.requestFocus();
  //   super.initState();
  // }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    focusNode.unfocus();
    focusNode.dispose();
    super.dispose();
  }

  void addChat(String message, bool isBot) {
    if (mounted)
      setState(() {
        setDate = true;
        if (isBot) isBotResponding = true;
        chats.add(ChatBotMessages(message.trim(), DateTime.now(), isBot));
      });
    if (isBot) scrollDown();
    if (!isBot)
      Future.delayed(
        Duration(milliseconds: 100),
        () => scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
        ),
      );
  }

  void botFinished() {
    isBotResponding = false;
  }

  void scrollDown() {
    Future.doWhile(() async {
      await Future.delayed(
        Duration(milliseconds: 100),
        () => scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
        ),
      );
      return isBotResponding;
    });
  }

  Future<void> getResponse(String text) async {
    // final request = ChatCompleteText(
    //   prompt: text,
    //   maxTokens: 500,
    //   model: DavinciModel(),
    // );

    // final response = await openAI
    //     .onCompleteText(request: request)
    //     .onError((error, stackTrace) {
    //   print(error);
    //   addChat("Sorry, I didn't understand what you said", true);
    //   if (mounted)
    //     setState(() {
    //       setDate = true;
    //       isWaiting = false;
    //     });
    //   return null;
    // });

    // final response = await openAI.onChatCompletion(request: request).onError((error, stackTrace) {
    //   print(error);
    //   addChat("Sorry, I didn't understand what you said", true);
    //   if (mounted)
    //     setState(() {
    //       setDate = true;
    //       isWaiting = false;
    //     });
    //   return null;
    // });

    // if (response != null) addChat(response.choices[0].text.trimLeft(), true);

    if (mounted)
      setState(() {
        setDate = true;
        isWaiting = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    ...List.generate(
                      chats.length,
                      (index) {
                        if (index > 0 &&
                            chats[index].time.day !=
                                chats[index - 1].time.day &&
                            chats[index].time.isAfter(chats[index - 1].time)) {
                          setDate = true;
                        } else if (index > 0) {
                          setDate = false;
                        }
                        return chats[index].isBot
                            ? BotMessage(
                                chatBotMessages: chats[index],
                                setDate: setDate,
                                isLast: index == chats.length - 1,
                                botFinished: botFinished,
                              )
                            : UserMessage(
                                chatBotMessages: chats[index],
                                setDate: setDate,
                                //profileUrl: widget.profileUrl,
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isWaiting) SizedBox(height: 15),
          if (isWaiting)
            SpinKitThreeBounce(
              size: 20,
              color: primaryColor,
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: secondaryColorDark)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      onChanged: (value) {
                        if (textEditingController.text.isNotEmpty) {
                          if (mounted)
                            setState(() {
                              setDate = true;
                            });
                        } else {
                          if (mounted)
                            setState(() {
                              setDate = true;
                              isTyping = false;
                            });
                        }
                      },
                      keyboardType: TextInputType.multiline,
                      controller: textEditingController,
                      focusNode: focusNode,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: "Ask anything...",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          //color: R.colors.midGrey,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 0, 8),
                child: InkWell(
                  onTap: _isListening ? _stopRecording : _startListening,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: secondaryColorDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Icon(
                        _isListening ? Icons.stop : Icons.mic,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                child: InkWell(
                  onTap: () {
                    if (textEditingController.text.isNotEmpty) {
                      if (mounted)
                        setState(() {
                          setDate = true;
                          isWaiting = true;
                        });
                      addChat(textEditingController.text, false);
                      getResponse(textEditingController.text.trim());
                      textEditingController.clear();
                      if (mounted)
                        setState(() {
                          setDate = true;
                          isTyping = false;
                        });
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: secondaryColorDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.send,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserMessage extends StatelessWidget {
  const UserMessage({
    Key? key,
    required this.chatBotMessages,
    required this.setDate,
  }) : super(key: key);
  final ChatBotMessages chatBotMessages;
  final bool setDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Wrap(children: [
                  Flexible(
                    child: Text(
                      chatBotMessages.message,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Nunito",
                        //color: R.colors.black,
                      ),
                    ),
                  ),
                ]),
                Text(
                  DateFormat.jm().format(chatBotMessages.time).toLowerCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Nunito',
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: secondaryColorDark,
              shape: BoxShape.circle,
            ),
            child: Center(
                child: Icon(
              Icons.person,
              color: Colors.white,
            )),
          ),
        ],
      ),
    );
  }
}

class BotMessage extends StatelessWidget {
  const BotMessage({
    Key? key,
    required this.chatBotMessages,
    required this.setDate,
    //required this.isSpeaking,
    required this.isLast,
    required this.botFinished,
  }) : super(key: key);
  final ChatBotMessages chatBotMessages;
  final bool setDate, isLast;
  final Function botFinished;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: secondaryColorDark,
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child: Icon(
                  Icons.computer,
                  color: Colors.white,
                )),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        onFinished: () {
                          botFinished();
                        },
                        animatedTexts: [
                          TyperAnimatedText(
                            chatBotMessages.message,
                            speed: const Duration(milliseconds: 50),
                            // child: Text(
                            //   chatBotMessages.message,
                            //   style: TextStyle(
                            //     fontSize: 14,
                            //     fontFamily: "Nunito",
                            //     color: R.colors.white,
                            //   ),
                            // ),
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontFamily: "Nunito",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    DateFormat.jm().format(chatBotMessages.time).toLowerCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
