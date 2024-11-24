import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:foofi/bubbles/reciever_bubble.dart';
import 'package:foofi/bubbles/sender_bubble.dart';
import 'package:foofi/buttons/choice_button.dart';
import 'package:foofi/buttons/more_detail_button.dart';
import 'package:foofi/buttons/speak_button.dart';
import 'package:foofi/color.dart';
import 'package:foofi/main.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  List<String> choices = [
    "사진을 업로드할게",
    "맛있는 사과를 추천해줘",
    "화장실이 어디야?",
  ];
  bool _isSpeechInitialized = false; // SpeechToText 초기화 여부

  final List<Widget> _messages = []; // 채팅 메시지 리스트

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _initializeSpeechToText();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  // 녹음 관련 변수 정의
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _recordedFilePath;

  // STT 관련 변수 정의
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  String _text = "음성을 입력하세요!";
  String _reply = ""; // ReceiverBubble에 띄울 reply

  /// Redcoder 초기화 함수
  Future<void> _initializeRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  /// Recoding 토글 함수
  Future<void> _toggleRecording() async {
    if (_isRecording) {
      // 녹음 중이면 중단
      await _stopRecording();
      // 녹음 중단 후 POST 요청 보내기
      await _sendTextPostRequest();
    } else {
      // 녹음 시작
      await _startRecording();
    }
  }

  /// SpeechToText 초기화 함수
  Future<void> _initializeSpeechToText() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isSpeechInitialized = true; // 초기화 완료 표시
        _text = "음성을 입력하세요";
      });
    } else {
      setState(() {
        _isSpeechInitialized = false; // 초기화 실패 표시
        _text = "음성 인식 기능을 사용할 수 없습니다.";
      });
    }
  }

  /// Recoding 시작 함수
  Future<void> _startRecording() async {
    // 경로 지정 (예시: 앱의 로컬 디렉토리에 저장)
    String path = await _getFilePath();

    try {
      // 파일 경로를 지정하여 녹음 시작
      await _recorder.startRecorder(
        toFile: path, // 경로를 지정
      );

      _recorder.setSubscriptionDuration(const Duration(milliseconds: 100));

      setState(() {
        _isRecording = true;
      });

      // 음성 인식 시작
      if (_isSpeechInitialized) {
        _startListening(); // 음성 인식 시작
      } else {
        setState(() {
          _text = "음성 인식 초기화 실패";
        });
      }
    } catch (e) {
      setState(() {
        _text = "녹음 시작 실패: $e";
      });
    }
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory(); // 앱의 문서 디렉토리
    return '${directory.path}/audio_recording.wav'; // 저장할 파일 경로
  }

  /// Recoding 중지 함수
  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    // 음성 인식 중지
    _stopListening();
  }

  /// 음성 인식 시작
  void _startListening() {
    _speechToText.listen(
      onResult: (result) {
        setState(() {
          _text = result.recognizedWords; // 음성 인식 결과를 텍스트로 업데이트
        });
      },
      listenFor: const Duration(seconds: 30), // 음성 인식 대기 시간 설정
      pauseFor: const Duration(seconds: 3), // 말하기 중 잠시 멈췄을 때 대기 시간
      partialResults: true, // 중간 결과를 받도록 설정
      localeId: 'ko_KR', // 언어 설정 (한국어로 설정)
    );
  }

  // 음성 인식 중지
  void _stopListening() {
    _speechToText.stop();
  }

  // POST 요청 메서드
  Future<void> _sendTextPostRequest() async {
    if (_text.isEmpty) {
      print('음성 인식 결과가 없습니다 !!');
      return;
    }

    // URL과 요청 데이터를 정의
    String url = '$ai_url/process_text';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text': _text,
        }),
      );

      if (response.statusCode == 200) {
        // 요청 성공 시 처리
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String reply = responseData['reply'] ?? '';

        setState(() {
          _reply = reply; // 서버에서 받은 reply를 업데이트

          // 메시지 리스트에 추가
          _messages.add(SenderBubble(text: _text));
          _messages.add(const SizedBox(height: 14.0));

          _messages.add(ReceiverBubble(text: _reply));
          _messages.add(const SizedBox(height: 14.0));
        });

        print('POST 요청 성공: ${response.body}');
        print(_text);
      } else {
        // 요청 실패 시 처리
        print('POST 요청 실패: ${response.statusCode}');
        print(_text);
      }
    } catch (error) {
      // 네트워크 오류 등 예외 처리
      print('POST 요청 오류: $error');
      print(_text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height / 852;
    final double width = MediaQuery.of(context).size.width / 393;

    return Scaffold(
      backgroundColor: yellow_001,
      appBar: AppBar(
        backgroundColor: yellow_001,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.home_outlined,
              size: 30,
              color: brown_001,
            ),
          ),
        ),
        title: Text(
          '대화하기',
          style: TextStyle(
            color: brown_001,
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 545,
              child: SizedBox(
                width: double.infinity,
                height: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ReceiverBubble(text: '무엇을 도와드릴까요?'),
                      const SizedBox(
                        height: 14.0,
                      ),
                      Column(
                        children: _messages,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 192,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 선택 버튼
                  // Wrap(
                  //   spacing: 8.0 * width,
                  //   alignment: WrapAlignment.center,
                  //   children: List.generate(choices.length, (index) {
                  //     return ChoiceButton(
                  //       onTap: () {},
                  //       text: choices[index],
                  //     );
                  //   }),
                  // ),

                  // 말하기 버튼 안내 문구
                  Padding(
                    padding: const EdgeInsets.only(top: 22.0),
                    child: Text(
                      '버튼을 눌러 말해보세요!',
                      style: TextStyle(
                        color: brown_001,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // 말하기 버튼
                  Padding(
                    padding: const EdgeInsets.only(top: 9.0),
                    child: SpeakButton(
                      onTap: _toggleRecording,
                      isRecording: _isRecording,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
