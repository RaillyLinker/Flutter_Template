import 'package:flutter_template/repositories/drift_db/daos/dao_todos.dart';
import 'package:flutter_template/repositories/drift_db/app_database.dart';

// [데이터베이스 객체 싱글톤 클래스]
class DatabaseProvider {
  static AppDatabase instance = AppDatabase();

  // (DAO 객체 생성 구역)
  static DaoTodos todosDao = instance.daoTodos;
}
