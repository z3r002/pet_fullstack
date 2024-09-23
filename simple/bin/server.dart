
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart' as shelf_static;
import '../bin/dtos/user_dto.dart';
import '../bin/methods/auth.dart';
import 'package:uuid/uuid.dart';



// Entry point of the application
Future<void> main() async {
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final cascade = Cascade()
      .add(_staticHandler)
      .add(_router.call);

  final server = await shelf_io.serve(
    logRequests().addHandler(cascade.handler),
    '0.0.0.0',
    port,
  );

  print('Serving at http://${server.address.host}:${server.port}');
  _watch.start();

}

// Статический обработчик файлов
final _staticHandler =
shelf_static.createStaticHandler('public', defaultDocument: 'index.html');

// Роутер
final _router = shelf_router.Router()
  ..get('/time', _timeHandler)
  ..get('/info.json', _infoHandler)
  ..get('/user/<id>', _getUserHandler) // GET запрос пользователя по ID
  ..post('/user', Auth.createUserHandler); // POST запрос для создания пользователя

// Обработчики маршрутов
Response _timeHandler(Request request) => Response.ok(
    DateTime.now().toUtc().toIso8601String(), headers: _jsonHeaders);

Response _getUserHandler(Request request, String id) {
  final user = User(id: id, name: 'User $id', email: 'user$id@example.com');
  return Response.ok(jsonEncode(user.toJson()), headers: _jsonHeaders); // Преобразуем в строку
}



// Обработчик информации о системе
Response _infoHandler(Request request) => Response(
  200,
  headers: {
    ..._jsonHeaders,
    'Cache-Control': 'no-store',
  },
  body: jsonEncode({ // Преобразуем Map в JSON строку
    'Dart version': _dartVersion,
    'uptime': _watch.elapsed.toString(),
    'requestCount': ++_requestCount,
  }),
);
// Хедеры для JSON
const _jsonHeaders = {
  'content-type': 'application/json',
};

// Системная информация
final _watch = Stopwatch();
int _requestCount = 0;
final _dartVersion = Platform.version.split(' ').first;