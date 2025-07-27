import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/todos.dart';
import 'daos/dao_todos.dart';

// >> flutter pub run build_runner build --delete-conflicting-outputs
// 위 명령어 입력시 아래 파일 생성
part 'app_database.g.dart'; // 자동 생성 파일

@DriftDatabase(tables: [Todos], daos: [DaoTodos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory(); // Windows에서 안전한 경로
    final dbPath = p.join(dir.path, 'db.sqlite');

    // 디렉토리 없으면 생성 (중요!)
    await Directory(dir.path).create(recursive: true);

    return NativeDatabase(File(dbPath));
  });
}

Future<File> getDatabaseFile() async {
  final dir = await getApplicationSupportDirectory();
  final path = p.join(dir.path, 'db.sqlite');
  return File(path);
}
