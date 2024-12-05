import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:foofi/function/permission_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:foofi/screens/overlay1_screen.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Trash extends StatefulWidget {
  const Trash({super.key});

  @override
  State<Trash> createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  List<String> choices = ["사진", "끝내기"];
  final bool _isSpeechInitialized = false; // SpeechToText 초기화 여부

  final List<Widget> _messages = []; // 채팅 메시지 리스트

  // 녹음 관련 변수 정의
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder(); // 오디오 녹음기
  final PermissionService _permissionService = PermissionService(); // 권한 서비스
  bool _isRecording = false; // 녹음 중인지 여부
  bool _isLoading = false; // ai 답변 기다리는 지 여부
  bool _canRecord = true; // 녹음 가능 여부
  late String _recordedFilePath; // 녹음된 파일 경로

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
    _initialize();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _audioRecorder.closeAudioSession();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw Exception('마이크 권한이 필요합니다.');
    }
  }

  /// Redcoder 초기화 함수
  // 초기 설정 : 권한 요청 및 오디오 세션 열기
  Future<void> _initialize() async {
    await _permissionService.requestPermissions();
    await _audioRecorder.openAudioSession();
  }

  // 오디오 녹음 및 처리
  Future<void> _recordAudio() async {
    print("dd");
    if (_isRecording) {
      final path = await _audioRecorder.stopRecorder(); // 녹음 중단
      if (path != null) {
        setState(() {
          _isRecording = false; // 녹음 상태 해체
          _recordedFilePath = path; // 녹음된 파일 경로 저장
          _isLoading = true; // 채팅 로딩
        });

        final audioFile = File(path); // 녹음된 파일 불러오기

        _text != await performSTT(path);
        print("STT: $_text");

        if (_text != null || _text.isNotEmpty) {
          setState(() {
            // 사용자 입력 말풍선 추가
            _messages.add(SenderTextBubble(text: _text));
          });

          _sendTextPostRequest(); // LLM에 요청
          print("결과는?!?!?! : $_reply");

          if (mounted) {
            setState(() {
              _isLoading = false; // 로딩 종료
              _canRecord = true;
            });
          } else {
            setState(() {
              _isLoading = false; // 로딩 종료
            });
          }
        } else {
          setState(() {
            _isLoading = false; // 로딩 종료
          });
        }
      }
    } else {
      print("녹음 시작");
      await _audioRecorder.startRecorder(
        toFile: 'audio_record.wav',
        codec: Codec.pcm16WAV,
      );
      setState(() {
        _isRecording = true; // 녹음 상태 활성화
      });
    }
  }

  /// Recoding 토글 함수
  // Future<void> _toggleRecording() async {
  //   if (_isRecording) {
  //     print('$_isRecording : 지금 녹음 중이니까 멈출게요');
  //     await _stopRecording();

  //     final file = File(_recordedFilePath!);
  //     if (await file.length() < 1000) {
  //       // 최소 크기 확인
  //       print("녹음된 파일이 너무 짧습니다.");
  //       showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return const AlertDialog(
  //               title: Text('녹음된 파일이 너무 짧습니다.'),
  //               content: Text('다시 녹음해주세요.'),
  //             );
  //           });
  //       return;
  //     }

  //     // STT 요청 수행
  //     String? recognizedText = await performSTT(_recordedFilePath!);
  //     print(recognizedText);
  //   } else {
  //     await _startRecording();
  //   }
  // }

  /// Recoding 시작 함수
  Future<void> _startRecording() async {
    try {
      // 마이크 권한 요청
      await _requestMicrophonePermission();

      // 경로 지정
      _recordedFilePath = await _getFilePath();
      print("파일 경로: $_recordedFilePath");

      // 녹음 시작
      await _audioRecorder.startRecorder(
        toFile: _recordedFilePath,
        sampleRate: 16000,
      );

      _audioRecorder.setSubscriptionDuration(const Duration(milliseconds: 100));
      print("녹음 상태: ${_audioRecorder.isRecording}");

      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      // 권한 또는 녹음 실패 시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('오류 발생'),
            content: Text('$e'),
          );
        },
      );
    }
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory(); // 앱의 문서 디렉토리
    return '${directory.path}/audio_recording.wav'; // 저장할 파일 경로
  }

  /// Recoding 중지 함수
  Future<void> _stopRecording() async {
    final filePath = _recordedFilePath;

    await _audioRecorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    if (File(filePath).existsSync()) {
      final file = File(filePath);
      final fileLength = await file.length();

      if (fileLength == 0 || fileLength < 1000) {
        // 파일 크기 검사
        print("녹음된 파일이 너무 짧거나 비어 있습니다.");
        setState(() {
          _text = "녹음된 파일이 너무 짧습니다. 다시 시도해주세요.";
        });

        if (fileLength < 1000) {
          // 최소 크기 확인
          print("녹음된 파일이 너무 짧습니다.");
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text('녹음된 파일이 너무 짧습니다.'),
                  content: Text('다시 녹음해주세요.'),
                );
              });
          return;
        }

        return;
      }
      // STT 요청 수행
      String? recognizedText = await performSTT(_recordedFilePath);
      print(recognizedText);

      print("녹음 완료: $filePath, 녹음 파일 길이 : $fileLength");
    } else {
      print("파일 생성 실패 또는 파일이 없습니다.");
    }
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
              imageUrl1: _detailedResult[1]['image_url'],
              imageUrl2: _detailedResult[2]['image_url'],
              originalPrice: _detailedResult[0]['original_price'],
              discountPrice: _detailedResult[0]['discount_price'],
              detailedList: responseData["detailed_results"],
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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 115,
                child: AppBar(
                  backgroundColor: yellow_001,
                  leading: Padding(
                    padding: EdgeInsets.only(left: 10.0.w, top: 10.0.h),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.home_outlined,
                        size: 30.w,
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
              ),
              Flexible(
                flex: 545,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.maxFinite,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      primary: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 25.0.h,
                          ),
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
              ),
              Flexible(
                flex: 192,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
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
                                //onTap: _toggleRecording,
                                // onTap: _isRecording
                                //     ? _stopRecording
                                //     : _startRecording,
                                onTap: _canRecord ? _recordAudio : null,
                                isRecording: _isRecording,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 63.h,
                        right: 32.w,
                        child: IconButton(
                          icon: Icon(
                            Icons.upload,
                            size: 25.w,
                          ),
                          onPressed: () {
                            _pickImg();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const OverlayScreen1(),
        ],
      ),
    );
  }
}
