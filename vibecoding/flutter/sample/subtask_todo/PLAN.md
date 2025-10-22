# PLAN.md - Subtask Todo 앱 구현 계획

이 문서는 `PRD.md`를 기반으로 Subtask Todo 앱의 기술적인 구현 계획을 정의합니다.

---

### 1. 프로젝트 아키텍처 (Project Architecture)

#### 1.1. 폴더 구조

-   `lib/`
    -   `main.dart`: 앱의 시작점. `MaterialApp` 및 `Provider` 설정.
    -   `models/`: 데이터 모델 클래스 (Todo, SubTask) 위치.
        -   `todo.dart`
        -   `sub_task.dart`
    -   `screens/`: 앱의 주요 화면 위젯.
        -   `home_screen.dart`: Todo 목록을 보여주는 메인 화면.
    -   `widgets/`: 재사용 가능한 UI 컴포넌트.
        -   `todo_list_item.dart`: 개별 Todo 항목을 표시하는 위젯.
        -   `subtask_list_item.dart`: 개별 Subtask 항목을 표시하는 위젯.
        -   `add_edit_dialog.dart`: Todo 및 Subtask 추가/수정을 위한 다이얼로그.
    -   `services/`: 외부 서비스와의 통신 및 비즈니스 로직.
        -   `storage_service.dart`: `shared_preferences`를 사용한 로컬 데이터 저장/로드 로직.
    -   `viewmodels/`: 상태 관리를 위한 `ChangeNotifier` 클래스.
        -   `todo_viewmodel.dart`: 앱의 상태 및 비즈니스 로직 관리.

#### 1.2. 레이어 구성

1.  **UI Layer**: (`screens/`, `widgets/`) - 사용자 인터페이스를 담당하며, 사용자의 입력을 받아 ViewModel에 전달합니다.
2.  **State Management Layer**: (`viewmodels/`) - `ChangeNotifier`를 사용하여 UI Layer와 Service Layer를 연결합니다. 앱의 상태를 관리하고, 상태 변경 시 UI에 알립니다.
3.  **Service Layer**: (`services/`) - 로컬 저장소와 같은 외부 종속성을 관리하고 비즈니스 로직을 처리합니다.
4.  **Data Layer**: (`models/`) - 앱에서 사용하는 데이터 구조를 정의합니다.

---

### 2. 데이터 모델 설계 (Data Model Design)

-   `shared_preferences`에 JSON 형태로 저장하기 위해 모든 모델 클래스는 `toJson()`과 `fromJson()` 팩토리 생성자를 포함해야 합니다.

#### 2.1. `SubTask` 클래스 (`lib/models/sub_task.dart`)

```dart
class SubTask {
  String id;
  String title;
  bool isDone;

  SubTask({required this.id, required this.title, this.isDone = false});

  factory SubTask.fromJson(Map<String, dynamic> json) {
    // ...
  }

  Map<String, dynamic> toJson() {
    // ...
  }
}
```

#### 2.2. `Todo` 클래스 (`lib/models/todo.dart`)

```dart
import 'sub_task.dart';

class Todo {
  String id;
  String title;
  bool isDone;
  List<SubTask> subtasks;

  Todo({
    required this.id,
    required this.title,
    this.isDone = false,
    List<SubTask>? subtasks,
  }) : this.subtasks = subtasks ?? [];

  factory Todo.fromJson(Map<String, dynamic> json) {
    // ...
  }

  Map<String, dynamic> toJson() {
    // ...
  }
}
```

---

### 3. 상태 관리 전략 (State Management Strategy)

-   **`ChangeNotifier` (with `Provider`)**: 앱의 핵심 상태인 `List<Todo>`를 관리하기 위해 `TodoViewModel` 클래스에서 사용합니다. Todo 목록에 대한 CRUD(생성, 읽기, 수정, 삭제) 작업이 발생하면 `notifyListeners()`를 호출하여 관련된 모든 UI 위젯을 업데이트합니다. 이는 전역적인 상태 관리에 적합합니다.

-   **`setState`**: 다이얼로그 내의 `TextField` 입력 값 관리, 체크박스 애니메이션 효과 등 특정 위젯에 국한된 일시적인 로컬 상태를 관리할 때 사용합니다. `ChangeNotifier`에 불필요한 부담을 주지 않고 해당 위젯만 효율적으로 리빌드할 수 있습니다.

---

### 4. 로컬 저장소 구현 방법 (Local Storage Implementation)

-   `shared_preferences`를 사용하여 키-값 형태로 데이터를 저장합니다.
-   **`StorageService` (`lib/services/storage_service.dart`)**:
    -   `saveTodos(List<Todo> todos)`:
        1.  `List<Todo>` 객체를 `List<Map<String, dynamic>>` 형태로 변환 (`toJson()` 호출).
        2.  `jsonEncode`를 사용하여 리스트를 단일 JSON 문자열로 변환.
        3.  `SharedPreferences.getInstance()`를 통해 인스턴스를 얻고, `setString('todos', jsonString)`으로 저장.
    -   `loadTodos() -> Future<List<Todo>>`:
        1.  `SharedPreferences.getInstance()`를 통해 인스턴스를 얻고, `getString('todos')`로 JSON 문자열을 로드.
        2.  문자열이 null이 아니면 `jsonDecode`를 사용하여 `List<dynamic>`으로 변환.
        3.  리스트를 순회하며 각 `Map`을 `Todo.fromJson()` 팩토리 생성자를 통해 `Todo` 객체로 변환하여 반환.

---

### 5. UI 화면 구성 (UI Screen Layout)

#### 5.1. 홈 화면 (`home_screen.dart`)

-   `Scaffold`를 사용하여 기본 구조를 잡고, `AppBar`에 "Subtask Todo" 제목을 표시합니다.
-   `Consumer<TodoViewModel>`을 사용하여 Todo 목록의 변경 사항을 구독합니다.
-   `ListView.builder`를 사용하여 `Todo` 목록을 표시하며, 각 항목은 `TodoListItem` 위젯으로 구성합니다.
-   `FloatingActionButton`을 추가하여 새 Todo를 추가하는 `add_edit_dialog`를 띄웁니다.

#### 5.2. Todo 항목 위젯 (`todo_list_item.dart`)

-   `ExpansionTile` 또는 `Card`와 `Column`을 조합하여 구현합니다.
-   헤더 부분에는 `Checkbox`, `ListTile`의 `title`, 수정/삭제 `IconButton`을 배치합니다.
-   펼쳐진 부분에는 `ListView`를 사용하여 `SubTask` 목록과 '서브태스크 추가' 버튼을 표시합니다.

#### 5.3. 추가/수정 다이얼로그 (`add_edit_dialog.dart`)

-   `showDialog` 함수를 통해 표시되는 `AlertDialog` 위젯입니다.
-   `StatefulWidget`으로 만들어 `TextField`의 상태를 관리합니다.
-   '저장' 버튼을 누르면 `TodoViewModel`의 해당 함수(e.g., `addTodo`, `updateTodo`)를 호출합니다.

---

### 6. 구현 순서 (Implementation Order)

1.  **1단계: 프로젝트 설정 및 모델링**
    -   `shared_preferences` 및 `provider` 의존성 추가.
    -   `todo.dart`, `sub_task.dart` 데이터 모델 클래스 및 `toJson`/`fromJson` 메서드 구현.

2.  **2단계: 서비스 및 상태 관리 기반 구축**
    -   `storage_service.dart` 구현 (데이터 저장/로드 기능).
    -   `todo_viewmodel.dart` 구현. `StorageService`를 사용하여 초기 데이터를 로드하고, Todo 목록을 관리하는 기본 CRUD 메서드 정의.

3.  **3단계: 핵심 UI 구현 (읽기)**
    -   `home_screen.dart`에서 `TodoViewModel`의 데이터를 받아 `ListView`로 Todo 목록을 표시.
    -   `todo_list_item.dart` 위젯을 만들어 각 Todo의 제목과 서브태스크 목록을 정적으로 표시.

4.  **4단계: 기능 구현 (추가 및 수정)**
    -   `FloatingActionButton`을 눌렀을 때 `add_edit_dialog`가 나타나도록 구현.
    -   다이얼로그에서 입력된 값으로 `TodoViewModel`의 `addTodo` 메서드를 호출하고, UI가 업데이트되는지 확인.
    -   Todo 및 Subtask 수정 기능 구현.

5.  **5단계: 기능 구현 (완료 및 삭제)**
    -   `Checkbox` 상태 변경 시 `TodoViewModel`의 `toggleTodoDone` 등의 메서드 호출.
    -   삭제 버튼 클릭 시 확인 다이얼로그를 띄우고, `deleteTodo` 메서드 호출.

6.  **6단계: 리팩토링 및 테스트**
    -   코드의 가독성을 높이고 중복을 제거.
    -   각 기능이 `PRD.md`의 요구사항에 맞게 동작하는지 최종 검토.
