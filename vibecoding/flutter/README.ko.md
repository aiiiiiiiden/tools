# Flutter 개발 환경 설정

macOS용 Flutter 개발 환경 자동 설치 및 검증 스크립트입니다.

> **⚠️ 중요: macOS 전용**
> 이 스크립트들은 **macOS 전용**으로 설계되었으며, 수정 없이는 Windows나 Linux에서 작동하지 않습니다.
> Windows 사용자는 [WSL2](#windows-사용자)를 사용하거나 수동으로 Flutter를 설치하세요.

## 개요

이 디렉토리에는 Flutter 개발 환경 설정을 간소화하는 두 가지 주요 스크립트가 포함되어 있습니다:

- **`install.sh`** - Flutter SDK 및 관련 도구 자동 설치 스크립트 (macOS 전용)
- **`doctor.sh`** - 설정을 검증하는 종합 확인 스크립트 (macOS 전용)

## 설치되는 도구

`install.sh` 스크립트는 다음 도구들을 설치하고 구성합니다:

1. **Flutter SDK** - 최신 안정 버전
2. **FVM (Flutter Version Management)** - 여러 Flutter 버전 관리
3. **Dart MCP Server** - Dart/Flutter용 Model Context Protocol 서버
4. **Firebase MCP** - MCP를 통한 Firebase 통합
5. **Gemini CLI** - Google의 Gemini AI 명령줄 인터페이스

### 사전 요구사항

스크립트는 누락된 경우 다음 항목을 자동으로 설치합니다:
- Homebrew
- Git
- Node.js 및 npm

## 설치 방법

### 빠른 시작

1. 스크립트에 실행 권한 부여:
```bash
chmod +x install.sh doctor.sh
```

2. 설치 스크립트 실행:
```bash
./install.sh
```

3. 터미널을 재시작하거나 셸 설정 다시 로드:
```bash
source ~/.zshrc  # zsh의 경우
# 또는
source ~/.bashrc  # bash의 경우
```

4. 설치 확인:
```bash
./doctor.sh
```

### install.sh가 수행하는 작업

설치 스크립트는 다음 단계를 수행합니다:

1. **사전 요구사항 확인** 및 필요시 설치:
   - Homebrew
   - Git
   - Node.js/npm

2. **Flutter SDK 설치**:
   - Flutter 저장소 클론 (stable 채널)
   - `~/development/flutter`에 설치
   - 초기 설정 및 precache 실행
   - 셸 설정에서 PATH 구성

3. **FVM 설치**:
   - Homebrew에 FVM tap 추가
   - Homebrew를 통해 설치

4. **Dart/Flutter MCP 서버 설정**:
   - Dart 버전 확인 (3.9+ 필요)
   - MCP 서버 기능 활성화

5. **Firebase MCP 설치**:
   - firebase-tools 전역 설치
   - MCP 지원을 위해 버전 13.21.0+ 필요

6. **Gemini CLI 설치**:
   - npm을 통해 전역 설치
   - 설정 안내 제공

7. **환경 구성**:
   - PATH에 Flutter 추가
   - PATH에 Dart pub-cache 추가
   - `.zshrc` 또는 `.bashrc` 업데이트

### 대화형 설치

스크립트는 다음 기능을 제공합니다:
- 기존 Flutter 설치를 재설치하기 전 확인 메시지
- 가독성을 위한 컬러 출력
- 장시간 실행되는 작업의 진행 상황 표시
- 명확한 오류 메시지 및 제안 사항

## 검증

### doctor.sh 사용하기

설치 후 검증 스크립트를 실행하세요:

```bash
./doctor.sh
```

### doctor.sh가 확인하는 항목

검증 스크립트는 다음 항목을 종합적으로 확인합니다:

1. **사전 요구사항**:
   - Homebrew
   - Git
   - Node.js
   - npm

2. **Flutter SDK**:
   - 설치 디렉토리
   - 명령어 가용성
   - PATH 구성
   - 현재 채널

3. **Dart**:
   - 버전
   - pub-cache PATH 구성

4. **FVM**:
   - 설치 여부
   - 설치된 Flutter 버전

5. **MCP 서버**:
   - Dart MCP 서버 가용성
   - Firebase MCP 가용성

6. **Gemini CLI**:
   - 설치 여부
   - 구성 상태

7. **셸 구성**:
   - `.zshrc`/`.bashrc`의 PATH 항목

8. **Flutter Doctor**:
   - 전체 `flutter doctor -v` 실행
   - 일반적인 문제 확인

### 결과 이해하기

스크립트는 다음과 같이 표시합니다:
- ✓ **초록색 체크**: 모든 것이 올바르게 작동
- ⚠ **노란색 경고**: 중요하지 않은 문제
- ✗ **빨간색 오류**: 주의가 필요한 중요한 문제

### 종료 코드

- `0`: 모든 확인 통과
- `1`: 일부 확인 실패

## 설치 후 단계

성공적인 설치 후 다음 단계를 완료하세요:

### 1. Android 라이선스 수락

Android 개발을 계획하는 경우:

```bash
flutter doctor --android-licenses
```

### 2. Gemini CLI 구성

Gemini CLI를 설치한 경우:

```bash
gemini config
```

### 3. Firebase 확장 프로그램 설치 (선택사항)

Gemini CLI Firebase 통합의 경우:

```bash
gemini extensions install https://github.com/gemini-cli-extensions/firebase/
```

### 4. MCP 서버 구성

편집기 또는 IDE에서 MCP 서버를 사용하려면:

- **Dart/Flutter MCP**: VS Code with Dart Code 확장 프로그램 v3.116+ 필요
- **Firebase MCP**: Claude Desktop, Cursor 또는 기타 MCP 클라이언트에서 구성

Claude Desktop용 MCP 구성 예시 (`~/Library/Application Support/Claude/claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "dart": {
      "command": "dart",
      "args": ["mcp-server"]
    },
    "firebase": {
      "command": "npx",
      "args": ["-y", "firebase-tools@latest", "mcp"]
    }
  }
}
```

### 5. 모든 것이 작동하는지 확인

빠른 확인 명령어 실행:

```bash
flutter --version
fvm --version
dart --version
firebase --version
gemini --version
```

## FVM 사용하기

FVM을 사용하면 여러 Flutter 버전을 관리할 수 있습니다:

### 특정 Flutter 버전 설치:
```bash
fvm install 3.24.0
```

### 전역적으로 버전 사용:
```bash
fvm global 3.24.0
```

### 특정 프로젝트에 버전 사용:
```bash
cd your-flutter-project
fvm use 3.24.0
```

### 설치된 버전 목록:
```bash
fvm list
```

## 문제 해결

### flutter 명령을 찾을 수 없음

설치 후 `flutter` 명령을 찾을 수 없는 경우:

1. 터미널 재시작
2. 또는 셸 설정 다시 로드:
   ```bash
   source ~/.zshrc  # 또는 ~/.bashrc
   ```

3. PATH가 구성되었는지 확인:
   ```bash
   echo $PATH | grep flutter
   ```

### 권한 문제

권한 오류가 발생하는 경우:

```bash
chmod +x install.sh doctor.sh
```

### 네트워크 문제

다운로드가 실패하는 경우:
- 인터넷 연결 확인
- 다시 시도 (스크립트는 멱등성을 가짐)
- GitHub 접근이 제한된 경우 VPN 사용

### Dart MCP 서버를 사용할 수 없음

Dart SDK 3.9+가 필요합니다. Flutter 업데이트:

```bash
flutter upgrade
dart --version
```

### Firebase MCP를 사용할 수 없음

최신 firebase-tools로 업데이트:

```bash
npm install -g firebase-tools@latest
```

또는 npx를 통해 사용:

```bash
npx -y firebase-tools@latest mcp
```

## 제거

Flutter 설치를 제거하려면:

```bash
# Flutter SDK 제거
rm -rf ~/development/flutter

# FVM 제거
brew uninstall fvm
brew untap leoafarias/fvm

# 전역 npm 패키지 제거
npm uninstall -g firebase-tools @google/gemini-cli

# 셸 설정에서 PATH 항목 제거
# ~/.zshrc 또는 ~/.bashrc를 편집하고 Flutter 관련 PATH export 제거
```

## 참고 자료

- **Flutter**: https://docs.flutter.dev
- **FVM**: https://fvm.app
- **Dart MCP**: https://dart.dev/tools/mcp-server
- **Firebase MCP**: https://firebase.google.com/docs/cli/mcp-server
- **Gemini CLI**: https://github.com/google-gemini/gemini-cli

## 시스템 요구사항

- **OS**: macOS 전용 (스크립트가 Homebrew 및 macOS 전용 도구 사용)
- **디스크 공간**: Flutter SDK 및 도구용 약 2GB
- **인터넷**: 다운로드에 필요

## Windows 사용자

이 스크립트들은 Windows에서 **기본적으로 호환되지 않습니다**. Windows를 사용하는 경우 다음 옵션이 있습니다:

### 옵션 1: WSL2 사용 (권장)

Windows Subsystem for Linux 2를 사용하면 Linux 환경에서 이 스크립트를 실행할 수 있습니다:

```powershell
# PowerShell(관리자 권한)에서 WSL2 설치
wsl --install

# WSL2를 실행하고 프로젝트로 이동
wsl
cd /mnt/c/Users/사용자이름/경로/vibecoding/flutter
chmod +x install.sh doctor.sh
./install.sh
```

### 옵션 2: 수동 설치

Flutter 공식 Windows 설치 가이드를 따르세요:
- https://docs.flutter.dev/get-started/install/windows

### 옵션 3: Git Bash 사용 (권장하지 않음)

Git Bash는 Homebrew를 지원하지 않아 이 스크립트 실행 시 오류가 발생합니다.

## Linux 사용자

이 스크립트는 Homebrew를 사용하며 Linux에서도 작동할 수 있지만, 일부 수정이 필요할 수 있습니다:
- 다른 셸을 사용하는 경우 셸 설정 경로 변경 필요
- Linux용 Homebrew가 설치되어 있어야 함: https://brew.sh

## 라이선스

이 스크립트는 개발 환경 설정을 위해 있는 그대로 제공됩니다.

## 기여

문제를 보고하거나 개선 사항을 제안해 주세요.
