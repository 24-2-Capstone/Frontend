import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:foofi/bubbles/receiver_image_bubble.dart';
import 'package:foofi/bubbles/sender_image_bubble.dart';
import 'package:foofi/bubbles/sender_text_bubble.dart';
import 'package:foofi/bubbles/receiver_text_bubble.dart';
import 'package:foofi/buttons/choice_button.dart';
import 'package:foofi/buttons/more_detail_button.dart';
import 'package:foofi/buttons/speak_button.dart';
import 'package:foofi/color.dart';
import 'package:foofi/function/perform_stt.dart';
import 'package:foofi/main.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  List<String> choices = ["사진", "끝내기"];
  final bool _isSpeechInitialized = false; // SpeechToText 초기화 여부

  final List<Widget> _messages = []; // 채팅 메시지 리스트

  // 녹음 관련 변수 정의
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _recordedFilePath;

  // STT 관련 변수 정의
  String _text = "음성을 입력하세요!";
  String _reply = ""; // ReceiverBubble에 띄울 reply
  List<Map<dynamic, dynamic>> _detailedResult = [];

  // 이미지 업로드 관련 변수 정의
  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImages = [];

  // 채팅창 스크롤 컨트롤러
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _scrollController.dispose();
    super.dispose();
  }

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
      final file = File(_recordedFilePath!);
      if (await file.exists()) {
        final fileBytes = await file.readAsBytes();
        print("녹음된 오디오 크기: ${fileBytes.length} bytes");
      }

      String? recognizedText = await performSTT(_recordedFilePath!);
      print(recognizedText);

      if (recognizedText != null && recognizedText.isNotEmpty) {
        setState(() {
          _text = recognizedText; // _text에 음성 인식 결과 저장
        });

        // 녹음 중단 후 POST 요청 보내기
        await _sendTextPostRequest();
      } else {
        print("음성 인식에 실패했습니다.");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text('음성 인식에 실패했습니다.'),
              );
            });
      }
    } else {
      // 녹음 시작
      await _startRecording();
    }
  }

  /// Recoding 시작 함수
  Future<void> _startRecording() async {
    // 경로 지정 (예시: 앱의 로컬 디렉토리에 저장)
    _recordedFilePath = await _getFilePath();
    print(_recordedFilePath);

    try {
      // 파일 경로를 지정하여 녹음 시작
      await _recorder.startRecorder(
        toFile: _recordedFilePath, // 경로를 지정
        sampleRate: 16000, // 샘플링 주파수 16000Hz 설정
      );

      _recorder.setSubscriptionDuration(const Duration(milliseconds: 100));

      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('녹음에 실패하였습니다!'),
              content: Text('$e'),
            );
          });
    }
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory(); // 앱의 문서 디렉토리
    return '${directory.path}/audio_recording.wav'; // 저장할 파일 경로
  }

  /// Recoding 중지 함수
  Future<void> _stopRecording() async {
    final filePath = _recordedFilePath;
    if (filePath != null && File(filePath).existsSync()) {
      final file = File(filePath);
      final fileLength = await file.length();

      if (fileLength == 0) {
        print("녹음이 제대로 되지 않았습니다. 파일이 비어있습니다.");
        return;
      }

      print("녹음이 완료되었습니다: $filePath");
    } else {
      print("파일이 생성되지 않았습니다.");
      return;
    }

    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
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
        // detailed_results가 null인 경우 빈 리스트로 초기화
        final List<Map<String, dynamic>> detailedResults =
            (responseData['detailed_results'] as List<dynamic>?)
                    ?.cast<Map<String, dynamic>>() ??
                [];
        print(detailedResults);

        setState(() {
          _reply = reply; // 서버에서 받은 reply를 업데이트
          _detailedResult = detailedResults; // 서버에서 받은 detail을 업데이트

          // 메시지 리스트에 추가
          _messages.add(SenderTextBubble(text: _text));
          _messages.add(const SizedBox(height: 14.0));
          _scrollToBottom(); // 서버 응답 메시지 추가 시 스크롤

          if (_detailedResult.isEmpty) {
            _messages.add(ReceiverTextBubble(text: _reply));
            _messages.add(const SizedBox(height: 14.0));
          } else {
            _messages.add(ReceiverImageBubble(
              text: '조회된 사과 목록입니다.',
              name: _detailedResult[0]['product_name'],
              imageUrl: _detailedResult[0]['image_url'],
              originalPrice: _detailedResult[0]['original_price'],
              discountPrice: _detailedResult[0]['discount_price'],
            ));
            _messages.add(const SizedBox(height: 14.0));
          }
          _scrollToBottom(); // 서버 응답 메시지 추가 시 스크롤
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

  Future<void> _pickImg() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, // 갤러리에서 이미지 선택
      maxWidth: 1024, // 선택 이미지의 최대 너비 (옵션)
      maxHeight: 1024, // 선택 이미지의 최대 높이 (옵션)
      imageQuality: 85, // 이미지 품질 (0-100, 옵션)
    );

    if (image != null) {
      setState(() {
        _pickedImages = [image]; // 선택된 이미지를 리스트에 저장

        // 채팅 메시지에 이미지 추가
        _messages.add(SenderImageBubble(
            text: '이 사진과 같은 상품 찾아줘', image: _pickedImages.last));
        _messages.add(const SizedBox(height: 14.0));
        _scrollToBottom(); // 서버 응답 메시지 추가 시 스크롤
      });

      // 서버로 이미지 전송
      await _sendImageToServer(File(image.path));
    } else {
      print("이미지를 선택하지 않았습니다.");
    }
  }

  Future<void> _sendImageToServer(File imageFile) async {
    try {
      // 이미지 파일을 읽고 Base64로 인코딩
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      // 서버 URL 설정
      String url = '$ai_url/process_image';

      // POST 요청
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image': base64Image, // Base64로 인코딩된 이미지 전송
        }),
      );

      if (response.statusCode == 200) {
        // 서버 응답 처리
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String reply = responseData['reply'] ?? '결과 없음';
        print(responseData);

        // UI에 응답 메시지 추가
        setState(() {
          _messages.add(ReceiverTextBubble(text: reply));
          _messages.add(const SizedBox(height: 14.0));
          _scrollToBottom(); // 서버 응답 메시지 추가 시 스크롤
        });

        print('POST 요청 성공: ${response.body}');
      } else {
        print('POST 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('이미지 처리 또는 POST 요청 오류: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 5),
          curve: Curves.easeOut,
        );
      }
    });
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
                  controller: _scrollController,
                  primary: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ReceiverTextBubble(text: '무엇을 도와드릴까요?'),
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
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                  Positioned(
                    top: 50.0,
                    right: 0.0,
                    child: Wrap(
                      spacing: 8.0 * width,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      direction: Axis.vertical,
                      children: [
                        ChoiceButton(
                          onTap: () async {
                            await _pickImg();
                          },
                          text: choices[0],
                        ),
                        ChoiceButton(
                          onTap: () {},
                          text: choices[1],
                        ),
                      ],
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
