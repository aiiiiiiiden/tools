# TASKS.md - Subtask Todo 앱 개발 작업 목록

`PLAN.md`에 정의된 구현 순서에 따른 개발 작업 체크리스트입니다.

-   `[ ]`: 미완료 (Not Started)
-   `[~]`: 진행 중 (In Progress)
-   `[x]`: 완료 (Done)

---

### 1단계: 프로젝트 설정 및 모델링

-   [x] `provider` 의존성 추가 (`pubspec.yaml`)
-   [x] `todo.dart` 모델 클래스 생성
-   [x] `todo.dart`에 `toJson()` 및 `fromJson()` 메서드 구현
-   [x] `todo.dart`에 `copyWith()` 메서드 구현
-   [x] `uuid` 의존성 추가 (`pubspec.yaml`)
-   [x] `sub_task.dart` 모델 클래스 생성
-   [x] `sub_task.dart`에 `toJson()` 및 `fromJson()` 메서드 구현
-   [x] `sub_task.dart`에 `copyWith()` 메서드 구현

### 2단계: 서비스 및 상태 관리 기반 구축

-   [x] `services/storage_service.dart` 파일 생성
-   [x] `StorageService` 클래스에 `saveTodos` 메서드 구현
-   [x] `StorageService` 클래스에 `loadTodos` 메서드 구현
-   [x] `viewmodels/todo_viewmodel.dart` 파일 생성
-   [x] `TodoViewModel` 클래스에 `ChangeNotifier` 상속
-   [x] `TodoViewModel`에 Todo 목록(`List<Todo>`) 상태 변수 선언
-   [x] `TodoViewModel` 생성자에서 `StorageService.loadTodos()`를 호출하여 데이터 로드
-   [x] `TodoViewModel`에 Todo 추가/수정/삭제 기본 메서드 정의
-   [x] `lib/models/todo_inherited_model.dart` 파일 생성
-   [x] `TodoInheritedModel` 클래스에 `InheritedModel` 상속
-   [x] `TodoInheritedModel`에 Todo 목록 관리 기능 구현
-   [x] `TodoInheritedModel`에 `addTodo`, `updateTodo`, `deleteTodo` 메서드 구현
-   [x] `TodoInheritedModel`에 `toggleTodoComplete` 메서드 구현
-   [x] `TodoInheritedModel`에 `StorageService`와 연동하여 자동 저장 기능 구현
-   [x] `TodoInheritedModel`에 aspect 기반으로 특정 Todo만 업데이트할 수 있도록 구현

### 3단계: 핵심 UI 구현 (읽기)

-   [x] `screens/home_screen.dart` 파일 생성
-   [x] `main.dart`에 `TodoInheritedModel` 설정
-   [x] `HomeScreen`에서 `TodoInheritedModel`의 데이터를 받아 `ListView`로 Todo 목록 표시
-   [x] `widgets/todo_list_item.dart` 파일 생성
-   [x] `TodoListItem` 위젯에서 Todo 제목, 체크박스, 서브태스크 목록 기본 레이아웃 구현
-   [x] `widgets/subtask_list_item.dart` 파일 생성
-   [x] `SubtaskListItem` 위젯에서 Subtask 제목, 체크박스 기본 레이아웃 구현

### 4단계: 기능 구현 (추가 및 수정)

-   [x] `HomeScreen`에 `FloatingActionButton` 추가
-   [x] `widgets/add_edit_dialog.dart` 파일 생성
-   [x] `FloatingActionButton` 클릭 시 Todo 추가 다이얼로그 표시
-   [x] 다이얼로그에서 입력된 값으로 `TodoViewModel.addTodo` 호출 및 UI 반영 확인
-   [x] Todo 항목의 수정 버튼 클릭 시 제목 수정 다이얼로그 표시 및 기능 구현
-   [x] '서브태스크 추가' 버튼 클릭 시 Subtask 추가 다이얼로그 표시 및 기능 구현
-   [x] Subtask 항목의 수정 버튼 클릭 시 제목 수정 다이얼로그 표시 및 기능 구현

### 5단계: 기능 구현 (완료 및 삭제)

-   [x] Todo 체크박스 클릭 시 `TodoViewModel.toggleTodoDone` 호출 및 UI 반영 확인
-   [x] Subtask 체크박스 클릭 시 TodoViewModel.toggleSubTaskDone 호출 및 UI 반영 확인
-   [x] Todo 삭제 버튼 클릭 시 확인 다이얼로그 표시
-   [x] 확인 시 `TodoViewModel.deleteTodo` 호출 및 UI 반영 확인
-   [x] Subtask 삭제 버튼 클릭 시 TodoViewModel.deleteSubTask 호출 및 UI 반영 확인

### 6단계: 리팩토링 및 최종 검토

-   [x] 전체 코드 리뷰 및 중복 코드 제거
-   [x] 주석 추가 및 코드 포맷팅 (dart format .)
-   [x] PRD.md 요구사항과 모든 기능이 일치하는지 최종 검토
