import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bytebrahmand_codeshastra/constants/colors.dart';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:intl/intl.dart';

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

  @override
  void initState() {
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    focusNode = FocusNode();
    focusNode.requestFocus();
    super.initState();
  }

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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: secondaryColorDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.speak,
                        size: 20,
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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: secondaryColorDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.send,
                        size: 20,
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
                        fontSize: 14,
                        fontFamily: "Nunito",
                        //color: R.colors.black,
                      ),
                    ),
                  ),
                ]),
                Text(
                  DateFormat.jm().format(chatBotMessages.time).toLowerCase(),
                  style: TextStyle(
                    fontSize: 12,
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
                              fontSize: 14,
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
                      fontSize: 12,
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
