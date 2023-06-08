import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:dart_demo_backend/database/database_client.dart';
import 'package:dart_demo_backend/models/user.dart';
import 'package:shelf/shelf.dart';

Future<Response> login(Request request) async {
  String bodyString = await request.readAsString();
  Map<String, dynamic> body = jsonDecode(bodyString);

  String email = body["email"];
  String password = body["password"];

  User? user = await DatabaseClient.provider.findUserByEmail(email);

  if (user == null) {
    return Response.badRequest(
      body: jsonEncode({"message": "User does not exist"}),
      headers: { 'content-type': 'application/json' },
    );
  }

  if (!BCrypt.checkpw(password, user.password)) {
    return Response.unauthorized(
      jsonEncode({"message": "Incorrect password"}),
      headers: { 'content-type': 'application/json' },
    );
  }

  return Response.ok(
    jsonEncode({ 
      "id": user.id,
      "name": user.name,
      "email": user.email
    }),
    headers: { 'content-type': 'application/json' },
  );
}

Future<Response> signup(Request request) async {
  String bodyString = await request.readAsString();
  Map<String, dynamic> body = jsonDecode(bodyString);

  String name = body["name"];
  String email = body["email"];
  String password = body["password"];

  User? user = await DatabaseClient.provider.findUserByEmail(email);

  if (user != null) {
    return Response.badRequest(
      body: jsonEncode({"message": "User already exist"}),
      headers: { 'content-type': 'application/json' },
    );
  }

  String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

  await DatabaseClient.provider.addUser(
    name: name, 
    email: email, 
    password: hashedPassword,
  );

  return Response.ok(
    jsonEncode({"message": "User added successfully"}),
    headers: { 'content-type': 'application/json' },
  );
}
