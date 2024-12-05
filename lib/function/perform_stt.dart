import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String?> performSTT(String audioFilePath) async {
  try {
    // 오디오 파일을 base64로 인코딩
    final file = File(audioFilePath);
    final fileBytes = await file.readAsBytes(); // 파일을 바이트로 읽기
    final base64userAudio = base64Encode(fileBytes); // Base64 인코딩

    print(base64userAudio);

    const String url = "https://norchestra.maum.ai/harmonize/dosmart";
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "cache-control": "no-cache",
    };

    final Map<String, dynamic> data = {
      "app_id": "2533d2e6-bb6a-519c-a7c2-88464189f1e7",
      "name": "sejong_conformer_stt_base64",
      "item": ["rcz-kor-base-base64"],
      "param": [base64userAudio],
    };

    // POST 요청 보내기
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse["text"] ?? ""; // 결과 텍스트 반환
    } else {
      print("에러 발생: ${response.statusCode}, ${response.body}");
      return null;
    }
  } catch (e) {
    print("STT 요청 중 오류 발생: $e");
    return null;
  }
}
