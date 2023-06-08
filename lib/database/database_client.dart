import 'package:dart_demo_backend/models/user.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DatabaseClient {

  DatabaseClient._();

  static final DatabaseClient provider = DatabaseClient._();

  Db? _db;

  Future<Db> get database async {
    if (_db != null) return _db!;

    _db = await Db.create("----Database Connection URL----");
    await _db!.open();
    return _db!;
  }

  Future<User?> findUserByEmail(String email) async {
    Db db = await database;

    Map<String, dynamic>? data = await db.collection("users").findOne(
      where.eq("email", email)
    );

    if (data != null) {
      print(data.toString());
      return User(
        id: (data["_id"] as ObjectId).$oid, 
        name: data["name"], 
        email: data["email"], 
        password: data["password"]
      );
    }
    else {
      return null;
    }
  }

  Future<void> addUser({
    required String name,
    required String email,
    required String password
  }) async {
    Db db = await database;

    await db.collection("users").insert({
      "name": name,
      "email": email,
      "password": password
    });
  }
}