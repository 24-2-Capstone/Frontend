import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:foofi/bubbles/receiver_image_bubble.dart';
import 'package:foofi/bubbles/receiver_loading_bubble.dart';
import 'package:foofi/bubbles/receiver_map_bubble.dart';
import 'package:foofi/bubbles/receiver_text_bubble.dart';
import 'package:foofi/bubbles/sender_image_bubble.dart';
import 'package:foofi/bubbles/sender_text_bubble.dart';
import 'package:foofi/buttons/choice_button.dart';
import 'package:foofi/buttons/speak_button.dart';
import 'package:foofi/color.dart';
import 'package:foofi/function/perform_tts.dart';
import 'package:foofi/main.dart';
import 'package:foofi/screens/overlay1_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _recordedFilePath;
  String? _sttResult;
  String _text = '';
  String _reply = '';
  bool isfirstChoice = true; // 맨 처음 선택지 표시
  bool _isLoading = false; // 말풍선 로딩 상태 관리

  final List<Widget> _messages = [];
  List<Map<dynamic, dynamic>> _detailedResult = [];

  // 채팅창 스크롤 컨트롤러
  late ScrollController _scrollController;

  // 이미지 업로드 관련 변수 정의
  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImages = [];

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _initializeChat(); // 비동기 작업 호출

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _recorder.closeAudioSession();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }
    await _recorder.openAudioSession();
  }

  // 비동기 작업을 위한 메서드
  Future<void> _initializeChat() async {
    final filePath = await performTTS('무엇을 도와드릴까요?');

    if (filePath != null) {
      await playAudio(filePath);
    }
  }

  Future<void> _toggleRecording() async {
    try {
      if (_isRecording) {
        // 녹음 중단
        final filePath = await _recorder.stopRecorder();
        setState(() {
          _isRecording = false;
          _recordedFilePath = filePath;
        });
        if (_recordedFilePath != null) {
          // STT 요청
          await _performSTT(_recordedFilePath!);
        }
      } else {
        // 녹음 시작
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/recorded_audio.wav';

        // 파일 경로 디버깅
        print("녹음 파일 경로: $filePath");

        // 녹음 시작
        await _recorder.startRecorder(
          toFile: filePath,
          codec: Codec.pcm16WAV,
          sampleRate: 16000,
        );

        setState(() {
          _isRecording = true;
          _recordedFilePath = filePath; // 경로를 미리 저장
        });
      }
    } catch (e) {
      print("녹음 중 오류 발생: $e");
      setState(() {
        _isRecording = false;
        _sttResult = "녹음 중 오류 발생: $e";
      });
    }
  }

  Future<void> _performSTT(String audioFilePath) async {
    try {
      // 오디오 파일을 base64로 인코딩
      final file = File(audioFilePath);
      final fileBytes = await file.readAsBytes();
      final base64userAudio = base64Encode(fileBytes);
      print("Base64 길이: $base64userAudio");

      const String url = "https://norchestra.maum.ai/harmonize/dosmart";
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "cache-control": "no-cache",
      };

      final Map<String, dynamic> data = {
        "app_id": "2533d2e6-bb6a-519c-a7c2-88464189f1e7",
        "name": "sejong_conformer_stt_base64",
        "item": ["rcz-kor-base-base64"], // 배열로 수정
        "param": [base64userAudio],
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      print("응답 상태 코드: ${response.statusCode}");
      print("응답 본문: ${response.body}");
      setState(() {
        _text = response.body;
      });
      _messages.add(SenderTextBubble(text: response.body));
      _messages.add(SizedBox(height: 14.h));
      _scrollToBottom();
      _sendTextPostRequest();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          //_sttResult = jsonResponse["text"] ?? "결과 없음";
          _sttResult = jsonDecode(response.body);
        });
      } else {
        print("STT 요청 실패: ${response.statusCode}, ${response.body}");
        setState(() {
          _sttResult = "STT 요청 실패";
        });
      }
    } catch (e) {
      print("STT 요청 중 오류 발생: $e");
      setState(() {
        _sttResult = "오류 발생: $e";
      });
    }
  }

  // POST 요청 메서드
  Future<void> _sendTextPostRequest() async {
    if (_text.isEmpty) {
      print('음성 인식 결과가 없습니다 !!');
      return;
    }

    // 로딩 중 상태로 설정하고 "..." 추가
    setState(() {
      _isLoading = true;
      _messages.add(const ReceiverLoadingBubble());
      _scrollToBottom(); // 스크롤을 가장 아래로 이동
    });

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
        final filePath = await performTTS(reply);

        if (filePath != null) {
          await playAudio(filePath);
        }

        setState(() {
          _reply = reply; // 서버에서 받은 reply를 업데이트
          _detailedResult = detailedResults; // 서버에서 받은 detail을 업데이트

          // "..." 말풍선을 제거
          _messages.removeLast();

          if (_detailedResult.isEmpty) {
            _messages.add(ReceiverTextBubble(text: _reply));
            _messages.add(SizedBox(height: 14.0.h));
          } else {
            _messages.add(ReceiverImageBubble(
              //text: '조회된 상품 목록입니다.',
              text: reply,
              name: _detailedResult[0]['product_name'],
              imageUrl: _detailedResult[0]['image_url'],
              imageUrl1: _detailedResult[1]['image_url'],
              imageUrl2: _detailedResult[2]['image_url'],
              originalPrice: _detailedResult[0]['original_price'] ?? 0,
              discountPrice: _detailedResult[0]['discount_price'] ?? 0,
              detailedList: responseData["detailed_results"],
            ));
            _messages.add(SizedBox(height: 14.0.h));
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
    } finally {
      setState(() {
        _isLoading = false; // 로딩 상태 해제
      });
    }
  }

  Future<void> playAudio(String filePath) async {
    final player = AudioPlayer();

    try {
      // 파일 경로 기반으로 재생
      await player.play(DeviceFileSource(filePath));
      print("오디오 재생 성공");
    } catch (e) {
      print("오디오 재생 중 오류 발생: $e");
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

      // 로딩 중 상태로 설정하고 "..." 추가
      setState(() {
        _isLoading = true;
        _messages.add(const ReceiverLoadingBubble());
        _scrollToBottom(); // 스크롤을 가장 아래로 이동
      });

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

        final filePath = await performTTS(reply);

        if (filePath != null) {
          await playAudio(filePath);
        }
        if (reply == "추천할 상품이 없습니다. 다른 이미지를 시도해보세요.") {
          setState(() {
            _messages.removeLast();
            _messages.add(ReceiverTextBubble(text: reply));
            _messages.add(SizedBox(height: 14.0.h));
            _scrollToBottom();
          });
        }

        setState(() {
          // detailed_results가 null인 경우 빈 리스트로 초기화
          final List<Map<String, dynamic>> detailedResults =
              (responseData['detailed_results'] as List<dynamic>?)
                      ?.cast<Map<String, dynamic>>() ??
                  [];

          // UI에 응답 메시지 추가

          // "..." 말풍선을 제거
          _messages.removeLast();

          if (detailedResults.isEmpty) {
            _messages.add(ReceiverTextBubble(text: reply));
            _messages.add(SizedBox(height: 14.0.h));
          } else {
            _messages.add(ReceiverImageBubble(
              text: reply,
              name: detailedResults[0]['product_name'],
              imageUrl: detailedResults[0]['image_url'],
              imageUrl1: detailedResults[1]['image_url'],
              imageUrl2: detailedResults[2]['image_url'],
              originalPrice: detailedResults[0]['original_price'] ?? 0,
              discountPrice: detailedResults[0]['discount_price'] ?? 0,
              detailedList: responseData["detailed_results"],
            ));
            _messages.add(SizedBox(height: 14.0.h));
          }
          _scrollToBottom(); // 서버 응답 메시지 추가 시 스크롤
        });

        print('POST 요청 성공: ${response.body}');
      } else {
        print('POST 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
        _sttResult = "녹음 중 오류 발생: $e";
      });
      print('이미지 처리 또는 POST 요청 오류: $e');
    } finally {
      setState(() {
        _isLoading = false; // 로딩 상태 해제
      });
    }
  }

  /// 스트롤
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            //mainAxisSize: MainAxisSize.min,
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
                          if (isfirstChoice)
                            Column(
                              children: [
                                SizedBox(
                                  height: 80.h,
                                ),
                                ChoiceButton(
                                    onTap: () {
                                      setState(() {
                                        isfirstChoice = false;
                                        _messages.add(SenderTextBubble(
                                            text: '맛있는 사과를 추천해줘'));
                                        _messages.add(SizedBox(height: 14.h));
                                        _text = '맛있는 사과를 추천해줘';
                                        _sendTextPostRequest();
                                      });
                                    },
                                    text: "맛있는 사과를\n추천해줘"),
                                SizedBox(
                                  height: 30.h,
                                ),
                                ChoiceButton(
                                    onTap: () async {
                                      setState(() {
                                        isfirstChoice = false;
                                        _messages.add(
                                          SenderTextBubble(text: '계산대는 어디 있어?'),
                                        );
                                        _messages.add(SizedBox(height: 14.h));
                                        _text = '계산대는 어디 있어?';
                                        //_sendTextPostRequest();
                                      });
                                      final filePath =
                                          await performTTS('계산대의 위치입니다!');

                                      if (filePath != null) {
                                        await playAudio(filePath);
                                        setState(() {
                                          _messages.add(
                                            ReceiverMapBubble(
                                                text: '계산대의 위치입니다!'),
                                          );
                                          _messages.add(SizedBox(height: 14.h));
                                        });
                                      }
                                    },
                                    text: "계산대는 어디 있어?"),
                              ],
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
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 22.0.h, bottom: 9.0.h),
                              child: Text(
                                _isRecording
                                    ? '녹음 중...'
                                    : (_recordedFilePath != null
                                        ? '버튼을 눌러 말해 보세요!'
                                        : '버튼을 눌러 말해 보세요!'),
                                style: TextStyle(
                                  color: brown_001,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Material(
                              color: _isRecording ? brown_001 : green_001,
                              borderRadius: BorderRadius.circular(100),
                              elevation: 4,
                              child: InkWell(
                                splashColor: green_001.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(100),
                                onTap: () async {
                                  setState(() {
                                    isfirstChoice = false;
                                  });
                                  _toggleRecording();
                                },
                                child: Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: _isRecording
                                        ? Border.all(style: BorderStyle.none)
                                        : Border.all(
                                            color: green_003.withOpacity(0.3),
                                            width: 3.0,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                          ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: _isRecording
                                        ? Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: SizedBox(
                                              width: 38,
                                              height: 38,
                                              child: LoadingIndicator(
                                                indicatorType:
                                                    Indicator.lineScalePulseOut,
                                                colors: [yellow_001],
                                                strokeWidth: 5.0,
                                              ),
                                            ),
                                          )
                                        : Icon(
                                            Icons.mic_none_sharp,
                                            color: brown_001,
                                            size: 38,
                                          ),
                                  ),
                                ),
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
                            setState(() {
                              isfirstChoice = false;
                            });
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
