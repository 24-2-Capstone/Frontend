# 🛒 세종대학교 2024-2 Capstone디자인(산학협력프로젝트) - AIMI

![대표사진](https://github.com/user-attachments/assets/4f210872-7557-4b4b-8da1-a7b466c149b2)

## ☝️ 목차
1. [프로젝트 소개](#1-프로젝트-소개)
    - [수상 내역](#수상-내역)
    
2. [개발 기술](#2-개발-기술)
    - [음성 녹음](#음성-녹음)
    - [사진 업로드](#사진-업로드)
    - [로딩 인디케이터](#로딩-인디케이터)
    - [오버레이 튜토리얼](#오버레이-튜토리얼)
    - [STT & TTS](#stt--tts)
    - [RAG 기반 상품 추천 기능](#rag-기반-상품-추천-기능)
3. [플러터 사용 이유](#3-플러터-사용-이유)
4. [lib 폴더 구조 설명](#4-lib-폴더-구조-설명)

&nbsp;

## 1. 프로젝트 소개
- 세종대학교 컴퓨터공학과 2024-2 Capstone 프로젝트입니다.
- [마음AI](https://maum.ai/)와의 기업연게로 API를 제공받아 사용하였습니다.
- 음성인식을 통한 마트 상품 추천 및 검색 기능을 제공하는 AI 마트 가이드입니다.
  
  ### 수상 내역
  - 2024.12.06 캡스톤 디자인 경진대회 - 우수상, 인기상
  - 2024.12.27 창의설계 경진대회 - 장려상

&nbsp;

## 2. 개발 기술
  ### 음성 녹음
  - flutter_sound, audioplayers를 사용하여 사용자의 음성을 임시저장하여 STT 변환 하였습니다.
  
  ### 사진 업로드
  - 사진 접근 권한을 요청한 후 갤러리에서 사진을 업로드하게 하였습니다.
  - image_picker 패키지를 사용하였습니다.

  ### 로딩 인디케이터
  - AI가 답변을 생상하는 시간 동안에는 ... 이 물결치는 애니메이션을 구현하여 나타나게 하였습니다.
  - 검색 화면에서 목록을 불러올 때 걸리는 시간 동안 커스텀 로딩 인디케이터를 만들어 오버레이 되도록 하였습니다.

  ### 오버레이 튜토리얼
  - 처음 음성 채팅 화면에 들어가면 터치하여 끌 수 있는 오버레이 튜토리얼이 화면과 겹치게 뜨도록 구현하였습니다.

  ---
  ### 마음 AI와 연계
  
  ### STT & TTS
  - 마음AI 측에서 제공받은 API를 통해 사용자의 음성을 text로 변환하였습니다.
  - 또한 AI모델의 text답변을 음성으로 변환하여 사용자에게 제공하였습니다.
  
  ### RAG 기반 상품 추천 기능
  - 사용자의 답변이나 질문을 text형태로 API 요청을 보내 상품 추천 답변을 제공받았습니다.
  - text에서 LLM을 사용하여 카테고리, 상품명, 조건을 추출하여 상품검색 DB에서 검색을 한 후, 검색된 결과를 기반으로 LLM 응답을 생성하였습니다.

&nbsp;

## 3. 플러터 사용 이유
  ### 다양한 플랫폼 지원
  - 기획 초기에는 AI 안내 로봇에 설치하여 작동시키려 웹 서비스를 기획하였으나, 여러 문제로 인해 로봇을 제공받지 못해 사람들이 손 쉽게 다운로드 받을 수 있는 앱으로 방향을 틀었습니다.
  안드로이드, IOS 둘 다 지원하는 플러터를 사용하기로 결정하였습니다.

&nbsp;

## 4. lib 폴더 구조 설명
- screens 폴더 : 각각의 화면들을 렌더링할 파일들을 모아놓음
- bubbles 폴더 : 채팅 화면에 쓰일 말풍선들을 class로 만들어 사용
- buttons 폴더 : 음성 녹음 버튼, 더보기 버튼 등 버튼들을 class로 만들어 사용
- fucntion 폴더 : stt & tts 처리, 상품 조회 등 api 요청을 하는 함수들을 따로 만들어 사용
- color.dart : 자주 쓰이는 색들을 변수로 만들어 사용

```
📦lib
 ┣ 📂bubbles
 ┃ ┣ 📜receiver_cashier_map_bubble.dart
 ┃ ┣ 📜receiver_image_bubble.dart
 ┃ ┣ 📜receiver_image_bubble_one.dart
 ┃ ┣ 📜receiver_loading_bubble.dart
 ┃ ┣ 📜receiver_map_bubble.dart
 ┃ ┣ 📜receiver_text_bubble.dart
 ┃ ┣ 📜sender_image_bubble.dart
 ┃ ┗ 📜sender_text_bubble.dart
 ┣ 📂buttons
 ┃ ┣ 📜choice_button.dart
 ┃ ┣ 📜more_detail_button.dart
 ┃ ┗ 📜speak_button.dart
 ┣ 📂function
 ┃ ┣ 📜perform_stt.dart
 ┃ ┣ 📜perform_tts.dart
 ┃ ┣ 📜permission_service.dart
 ┃ ┣ 📜show_goods_dialog.dart
 ┃ ┣ 📜show_goods_location_dialog.dart
 ┃ ┗ 📜show_map_dialog.dart
 ┣ 📂screens
 ┃ ┣ 📜ad_screen.dart
 ┃ ┣ 📜arrive_info.dart
 ┃ ┣ 📜arrive_infot_search.dart
 ┃ ┣ 📜chatting_screen.dart
 ┃ ┣ 📜custom_loading_indicator.dart
 ┃ ┣ 📜home_screen.dart
 ┃ ┣ 📜map_painter.dart
 ┃ ┣ 📜overlay1_screen.dart
 ┃ ┣ 📜overlay2_screen.dart
 ┃ ┗ 📜search_screen.dart
 ┣ 📜color.dart
 ┗ 📜main.dart
```
