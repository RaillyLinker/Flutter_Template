import 'package:drift/drift.dart';
import 'package:drift/web.dart';

// Web: Use IndexedDB via WebDatabase
QueryExecutor openConnection() {
  return WebDatabase('app_db');
}
