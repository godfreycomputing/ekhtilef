import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import "../net/interceptor.dart";
import '../net/net.dart';
import '../../service_locator.dart';
import '../errors/base_error.dart';
import 'package:http_parser/http_parser.dart';

abstract class RemoteDataSource {
 Future<Either<BaseError, TModel>?> requestUploadFile<TModel, TResponse,EModel>({
   required TResponse Function(dynamic) converter,
   required String url,
   required String fileKey,
   required String filePath,
   MediaType? mediaType,
   Map<String, dynamic>? data,
   ProgressCallback? onSendProgress,
   ProgressCallback? onReceiveProgress,
   bool withAuthentication = false,
   bool withTenants = false,
   CancelToken? cancelToken,
 }) async {
   assert(converter != null);
   assert(url != null);

   // Specify the headers.
   final Map<String, String> headers = {};
   inject<HttpClient>().instance.interceptors.clear();
   // Get the language.
   inject<HttpClient>().instance.interceptors.add(LanguageInterceptor());
   if (withAuthentication) {
     inject<HttpClient>().instance.interceptors.add(AuthInterceptor());
   }

   // Send the request.
   final response = await inject<HttpClient>().upload<TResponse, EModel>(
     url: url,
     fileKey: fileKey,
     filePath: filePath,
     fileName: filePath.substring(filePath.lastIndexOf('/') + 1),
     mediaType: mediaType!,
     data: data!,
     headers: headers,
     onSendProgress: onSendProgress!,
     cancelToken: cancelToken!,
   );

   // convert jsonResponse to model and return it
   var responseModel;
   if(response.isLeft()){
     return Left((response as Left<BaseError, TResponse>).value);
   }
   else if(response.isRight()){
     responseModel = converter((response as Right<BaseError, TResponse>).value);
     return Right(responseModel);
   }
   return null;
 }

  /// [TModel] type of model response from server
  /// [TResponse]type of response from dart should be  dynamic map or List<dynamic>
  /// [EModel] type of error message when response status code is 500
  Future<Either<BaseError, TModel>?> request<TModel, TResponse,EModel>({
    required TResponse Function(dynamic) converter,
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    bool withAuthentication = false,
    CancelToken? cancelToken,
  }) async {
    assert(converter != null);
    assert(method != null);
    assert(url != null);

    // Specify the headers.
    final Map<String, String> headers = {};
    inject<HttpClient>().instance.interceptors.clear();
    // Get the language.
    inject<HttpClient>().instance.interceptors.add(LanguageInterceptor());
    if (withAuthentication) {
      inject<HttpClient>().instance.interceptors.add(AuthInterceptor());
    }
    // Send the request.
    final response = await inject<HttpClient>().sendRequest<TResponse,EModel>(
      method: method,
      url: url,
      headers: headers,
      queryParameters: queryParameters ?? {},
      body: body!,
      cancelToken: cancelToken!,
    );
    // convert jsonResponse to model and return it
    var responseModel;
    if(response.isLeft()){
      return Left((response as Left<BaseError, TResponse>).value);
    }
    else if(response.isRight()){
      responseModel = converter((response as Right<BaseError, TResponse>).value);
      return Right(responseModel);
    }
    return null;
  }
}
