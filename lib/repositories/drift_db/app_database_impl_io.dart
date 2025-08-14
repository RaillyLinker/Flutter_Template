import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// IO / Desktop / Mobile: Use native sqlite via sqlite3
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    final dbPath = p.join(dir.path, 'db.sqlite');
    await Directory(dir.path).create(recursive: true);
    return NativeDatabase(File(dbPath));
  });
}

// Utility used by import/export sample on IO platforms
Future<File> getDatabaseFile() async {
  final dir = await getApplicationSupportDirectory();
  final path = p.join(dir.path, 'db.sqlite');
  return File(path);
}
