import 'package:dart_demo_backend/dart_demo_backend.dart' as lib;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

void main(List<String> arguments) async {
  var app = Router();

  app.post('/login', lib.login);

  app.post('/signup', lib.signup);

  var server = await shelf_io.serve(app, 'ec2-13-234-119-31.ap-south-1.compute.amazonaws.com', 8080);

  // Enable content compression
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}
