import 'package:drift/drift.dart';
import '../tables/todos.dart';
import '../app_database.dart';

part 'dao_todos.g.dart';

@DriftAccessor(tables: [Todos])
class DaoTodos extends DatabaseAccessor<AppDatabase> with _$DaoTodosMixin {
  DaoTodos(AppDatabase db) : super(db);

  Stream<List<Todo>> watchAllTodos() => select(todos).watch();

  Future<int> insertTodo(Insertable<Todo> todo) => into(todos).insert(todo);

  Future deleteTodoById(int id) =>
      (delete(todos)..where((t) => t.id.equals(id))).go();
}
