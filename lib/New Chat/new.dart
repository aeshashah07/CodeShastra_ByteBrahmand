import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class RecordScreen extends StatefulWidget {
  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  late String _filePath;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
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
        String rawBody =
            '{"contents": [{"role": "user","parts": [{"text": $_text}]}]}';
        var response = await http.post(
            Uri.parse(
                "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=AIzaSyDZ7q5vFZARCv2nShdqnjqE4K7dh3z23PU"),
            body: rawBody);
        print("RESPONSE: ${response.body}");
      } else {
        setState(() => _isListening = false);
        print('Speech recognition not available');
      }
    }
  }

  Future<void> _stopRecording() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
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

    try {
      // File image = File(filePath);
      // var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
      // var length = await image.length();

      // var request = http.MultipartRequest("POST",
      //     Uri.parse("https://codeshastra-bytebrahmand.onrender.com/upload"));
      // var multipartFile = http.MultipartFile('audio_file', stream, length,
      //     filename: basename(image.path));
      // request.files.add(multipartFile);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://codeshastra-bytebrahmand.onrender.com/upload'),
      );
      request.files
          .add(await http.MultipartFile.fromPath('audio_file', filePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        // Decode response body
        var jsonResponse = await _decodeResponse(response);
        if (jsonResponse != null) {
          String audioUrl = jsonResponse['transcription'];
          print('Response: $jsonResponse');
          setState(() {
            _text = audioUrl;
          });
        }
      } else {
        print(
            'Failed to post audio: ${response.statusCode}  ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error posting audio: $e');
    }

    var response = await http
        .get(Uri.parse("https://codeshastra-bytebrahmand.onrender.com/"));
    print("EMPTY API" + response.body);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_text),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _isListening ? _stopRecording : _startListening,
              child: Icon(_isListening ? Icons.stop : Icons.mic),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }
}
