import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String?> performTTS(String text) async {
  final url = Uri.parse("https://norchestra.maum.ai/harmonize/dosmart");
  final headers = {
    "Content-Type": "application/json",
    "cache-control": "no-cache",
  };

  final data = {
    "app_id": "78777888-88f4-5357-bab9-f1599bc63840",
    "name": "sejong_tts_ko_w1",
    "item": ["spw-rftap-jhe-stream"],
    "param": [
      {
        "lang": 1,
        "sampleRate": 22050,
        "text": text,
        "speaker": 0,
        "audioEncoding": 0,
        "durationRate": 1.0,
        "emotion": 0,
        "padding": {"begin": 0.1, "end": 0.1},
        "profile": "none",
        "speakerName": "rftap_JHE",
      }
    ],
  };

  try {
    final response =
        await http.post(url, headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      print("text to speech 응답 성공");

      // 안전한 파일 경로 가져오기
      final directory = await getApplicationDocumentsDirectory();
      final outputFile = File("${directory.path}/output_audio.wav");

      // 파일 저장
      await outputFile.writeAsBytes(response.bodyBytes);
      print("오디오 파일이 저장되었습니다: ${outputFile.path}");

      return outputFile.path;
    } else {
      print("에러 발생: ${response.statusCode}, ${response.body}");
      return null;
    }
  } catch (e) {
    print("예외 발생: $e");
    return null;
  }
}
