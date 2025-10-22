# 개발 도구 모음집

개발 환경 설정 및 워크플로우를 간소화하기 위한 자동화 스크립트와 도구 모음입니다.

## 📋 사용 가능한 도구

### 🎯 바이브 코딩 (Vibe Coding)

바이브 코딩 개발 환경을 위한 도구 및 유틸리티입니다.

#### Flutter 개발 환경 설정
**위치:** `vibecoding/flutter/`

macOS용 Flutter 바이브 코딩 환경 자동 설치 및 검증 스크립트입니다.

**주요 기능:**
- ✅ FVM을 통한 Flutter SDK 자동 설치
- ✅ Dart/Flutter MCP 서버 설정
- ✅ Firebase MCP 통합
- ✅ Gemini CLI 설치 및 구성
- ✅ 종합적인 상태 검사를 통한 환경 검증

**빠른 시작:**
```bash
cd vibecoding/flutter
chmod +x install.sh doctor.sh
./install.sh
./doctor.sh
```

**문서:**
- [영어 설정 가이드](vibecoding/flutter/docs/SETUP.md)
- [한글 설정 가이드](vibecoding/flutter/docs/SETUP.ko.md)
- [프로젝트 README](vibecoding/flutter/README.md)

**플랫폼:** macOS 전용 (WSL2 지원 미검증)


## 🚀 시작하기

1. **저장소 클론:**
   ```bash
   git clone https://github.com/aiiiiiiiden/tools.git
   cd tools
   ```

2. **사용할 도구로 이동:**
   ```bash
   cd vibecoding/flutter # Flutter 바이브코딩 환경 설정
   ```

3. **각 도구의 README 파일**에 있는 상세 지침을 따르세요.

## 📁 저장소 구조

```
tools/
├── README.md                           # 이 파일 (영어)
├── README.ko.md                        # 이 파일 (한글)
├── vibecoding/                         # 바이브 코딩 도구
│   └── flutter/                        # Flutter 환경 설정
│       ├── install.sh                  # 설치 스크립트
│       ├── doctor.sh                   # 검증 스크립트
│       ├── README.md                   # 프로젝트 문서
│       └── docs/                       # 상세 가이드
│           ├── SETUP.md                # 영어 설정 가이드
│           ├── SETUP.ko.md             # 한글 설정 가이드
│           └── HELLOWORLD.ko.md        # Flutter 튜토리얼
```

## 🛠 도구 카테고리

### 개발 환경 설정
- **Flutter (바이브 코딩)** - FVM, MCP 서버, AI 도구를 포함한 완전한 Flutter 개발 환경

### 준비 중
더 많은 도구와 유틸리티가 개발되는 대로 이 모음집에 추가될 예정입니다.


## 📚 문서

각 도구는 자체 문서를 포함하고 있습니다:
- `docs/` - 상세 설정 및 사용 가이드

## 🤝 기여하기

기여, 이슈 제기, 기능 요청을 환영합니다!

**기여 방법:**
1. 저장소 포크
2. 기능 브랜치 생성
3. 변경사항 작성
4. Pull Request 제출

## 📬 연락처

- GitHub: [aiiiiiiiden/tools](https://github.com/aiiiiiiiden/tools)
- 이메일: aiiiiiiiden@gmail.com
- 이슈: [이슈 보고](https://github.com/aiiiiiiiden/tools/issues)

## 📄 라이선스

이 프로젝트는 개발 환경 설정 및 자동화를 위해 있는 그대로(as-is) 제공됩니다.

## 🌟 감사의 말

개발자 워크플로우를 단순화하고 수동 설정 부담을 줄이기 위한 자동화를 염두에 두고 제작되었습니다.

---

**저장소:** https://github.com/aiiiiiiiden/tools
