import 'package:get_storage/get_storage.dart';
import '../models/todo.dart';
import '../models/account.dart';

class StorageService {
  final GetStorage _box = GetStorage();

  /// Save a list of string items under a key
  Future<void> saveList({
    required String key,
    required List<String> items,
  }) async {
    await _box.write(key, items);
  }

  /// Retrieve a list of string items from a key
  List<String> getLists({
    required String key,
  }) {
    final data = _box.read<List>(key);
    if (data != null) {
      return data.map((item) => item.toString()).toList();
    }
    return [];
  }

  /// Save a list of Todo objects
  Future<void> saveTodos({
    required String key,
    required List<Todo> todos,
  }) async {
    final data = todos.map((todo) => todo.toJson()).toList();
    await _box.write(key, data);
  }

  /// Retrieve a list of Todo objects
  List<Todo> getTodos({
    required String key,
  }) {
    final data = _box.read<List>(key);
    if (data != null) {
      return data
          .map((item) => Todo.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Save account info
  Future<void> saveAccount(Account account) async {
    await _box.write('account_info', account.toJson());
  }

  /// Retrieve account info
  Account? getAccount() {
    final data = _box.read<Map<String, dynamic>>('account_info');
    if (data != null) {
      return Account.fromJson(data);
    }
    return null;
  }

  /// Clear account info (optional)
  Future<void> clearAccount() async {
    await _box.remove('account_info');
  }
}
