import 'dart:convert';

import '../errors/base_error.dart';

/// This model is general if API return model with status code like 500
/// We handle this error here  and [E] is specific model for different response.

class ErrorMessageModel<E> extends BaseError{
  ErrorMessageModel({
    required this.data,
    required this.errorCode,
    required this.message,
    required this.messages,
  });

  final E data;
  final int errorCode;
  final String message;
  final List<String> messages;

  factory ErrorMessageModel.fromJson(String str) => ErrorMessageModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ErrorMessageModel.fromMap(Map<String, dynamic> json) => ErrorMessageModel(
    data: json['data'],
    errorCode: json['errorCode'] ,
    message: json['message'] ,
    messages: List<String>.from(json['messages'].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    'data': data,
    'errorCode': errorCode ,
    'message': message ,
    'messages': messages == null ? null : List<dynamic>.from(messages.map((x) => x)),
  };

  @override
  List<Object> get props => [errorCode,message,messages];
}
