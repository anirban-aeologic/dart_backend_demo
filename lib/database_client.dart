import 'package:dart_demo_backend/models/user.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DatabaseClient {

  DatabaseClient._();

  static final DatabaseClient provider = DatabaseClient._();

  Db? _db;

  Future<Db> get database async {
    if (_db != null) return _db!;

    _db = await Db.create("mongodb+srv://dev:wGiPqFExc7YgvWjm@cluster0.eo9cj8s.mongodb.net/test?retryWrites=true&w=majority");
    await _db!.open();
    return _db!;
  }

  Future<User?> findUserByUsername(String username) async {
    Db db = await database;

    Map<String, dynamic>? data = await db.collection("users").findOne(
      where.eq("username", username)
    );

    if (data != null) {
      print(data.toString());
      return User(
        id: (data["_id"] as ObjectId).$oid, 
        name: data["name"], 
        username: data["username"], 
        password: data["password"]
      );
    }
    else {
      return null;
    }
  }

  Future<void> addUser({
    required String name,
    required String username,
    required String password
  }) async {
    Db db = await database;

    await db.collection("users").insert({
      "name": name,
      "username": username,
      "password": password
    });
  }
}