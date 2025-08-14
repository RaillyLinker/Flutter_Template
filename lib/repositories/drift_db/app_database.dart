import 'package:drift/drift.dart';
// Conditional openConnection implementations
import 'app_database_impl_io.dart'
    if (dart.library.html) 'app_database_impl_web.dart';

import 'tables/todos.dart';
import 'daos/dao_todos.dart';

// >> flutter pub run build_runner build --delete-conflicting-outputs
// 위 명령어 입력시 아래 파일 생성
part 'app_database.g.dart'; // 자동 생성 파일

@DriftDatabase(tables: [Todos], daos: [DaoTodos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;
}

// IO 구현에서는 파일 경로를 사용하므로, 필요시 별도 유틸을 io 파일에 둘 수 있습니다.
