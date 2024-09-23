 import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';
import '../../bin/dtos/user_dto.dart';


class Auth{
 static  Future<Response> createUserHandler(Request request) async {
     try {
       final payload = await request.readAsString();
       final User data = User.fromJson(jsonDecode(payload));

       final newUser = User(
         id: Uuid().v4(), // Генерация уникального ID
         name: data.name,
         email: data.email,
       );

       return Response.ok(jsonEncode(newUser.toJson()), headers: jsonHeaders); // Преобразуем в строку
     } catch (e) {
       return Response.internalServerError(body: 'Ошибка при обработке запроса: $e, request: ${request.readAsString()}');
     }
   }
 }
 const jsonHeaders = {
   'content-type': 'application/json',
 };
