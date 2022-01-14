import 'dart:convert';

import '../errors/base_error.dart';

/// This model is general if API return model with status code like 500
/// We handle this error here  and [E] is specific model for different response.

class ErrorMessageModel<E> extends BaseError{
  ErrorMessageModel({
    this.data,
    this.errorCode,
    this.message,
    this.messages,
  });

  final E? data;
  final int? errorCode;
  final String? message;
  final List<String>? messages;

  factory ErrorMessageModel.fromJson(String str) => ErrorMessageModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ErrorMessageModel.fromMap(Map<String, dynamic> json) => ErrorMessageModel(
    data: json["data"] == null ? null : json["data"],
    errorCode: json["errorCode"] == null ? null : json["errorCode"],
    message: json["message"] == null ? null : json["message"],
    messages: json["messages"] == null ? null : List<String>.from(json["messages"].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "data": data,
    "errorCode": errorCode == null ? null : errorCode,
    "message": message == null ? null : message,
    "messages": messages == null ? null : List<dynamic>.from(messages!.map((x) => x)),
  };

  @override
  List<Object> get props => [errorCode!,message!,messages!];
}
