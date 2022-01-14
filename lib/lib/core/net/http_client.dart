import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../errors/bad_request_error.dart';
import '../errors/base_error.dart';
import '../errors/cancel_error.dart';
import '../errors/conflict_error.dart';
import '../errors/forbidden_error.dart';
import '../errors/format_error.dart';
import '../errors/http_error.dart';
import '../errors/internal_server_error.dart';
import '../errors/net_error.dart';
import '../errors/not_found_error.dart';
import '../errors/socket_error.dart';
import '../errors/timeout_error.dart';
import '../errors/unauthorized_error.dart';
import '../errors/unknown_error.dart';
import '../model/error_message_model.dart';
import 'api_url.dart';
import 'http_method.dart';
import 'package:http_parser/http_parser.dart';


class HttpClient{
  Dio? _client;

  Dio get instance => _client!;

  HttpClient() {
    BaseOptions _options = BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 15000,
      sendTimeout: 10000,
      responseType: ResponseType.json,
      baseUrl: BASE_URL,
    );
    _client = Dio(_options);
  }

  Future<Either<BaseError, T>> sendRequest<T,E>({
    required HttpMethod method,
    required String url,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    CancelToken? cancelToken,
  }) async {
    assert(method != null);
    assert(url != null);
    // Get the response from the server
    Response response;
    try {
      switch (method) {
        case HttpMethod.GET:
          response = await _client!.get(
            url,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.POST:
          response = await _client!.post(
            url,
            data: body,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.PUT:
          response = await _client!.put(
            url,
            data: body,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.DELETE:
          response = await _client!.delete(
            url,
            data: body,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
      }
      try {
          // Get the decoded json
        if (response.data is String)
          return Right(json.decode(response.data) as T);
        else{
          return Right(response.data as T);
        }
      } on FormatException catch(e) {
        debugPrint(e.toString());
        return Left(FormatError());
      } catch (e) {
        debugPrint(e.toString());
        return Left(UnknownError());
      }
    }
    // Handling errors
    on DioError catch (e) {
      return Left(_handleDioError(e));
    }

    // Couldn't reach out the server
    on SocketException catch (e) {
      return Left(SocketError());
    }
  }

  Future<Either<BaseError, T>> upload<T, E>({
    required String url,
    required String fileKey,
    required String filePath,
    required String fileName,
    MediaType? mediaType,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    assert(url != null);
    assert(fileKey != null);

    Map<String, dynamic> dataMap = {};
    if (data != null) {
      dataMap.addAll(data);
    }
    if (filePath != null && fileName != null) {
      dataMap.addAll({
        fileKey: await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: mediaType ?? MediaType("image", "jpeg"),
        )
      });
    }
    try {
      final response = await _client!.post(
        url,
        data: FormData.fromMap(dataMap),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );

      try {
        // Get the decoded json
        if (response.data is String)
          return Right(json.decode(response.data) as T);
        else{
          return Right(response.data as T);
        }
      } on FormatException catch(e) {
        debugPrint(e.toString());
        return Left(FormatError());
      } catch (e) {
        debugPrint(e.toString());
        return Left(UnknownError());
      }
    }
    // Handling errors
    on DioError catch (e) {
      return Left(_handleDioError(e));
    }

    // Couldn't reach out the server
    on SocketException catch (e) {
      return Left(SocketError());
    }


  }

  BaseError _handleDioError<E>(DioError error) {
    
      if (error.error is SocketException) return SocketError();
      if (error.type == DioErrorType.response) {
        switch (error.response!.statusCode) {
          case 400:
            return BadRequestError();
          case 401:
            return UnauthorizedError();
          case 403:
            return ForbiddenError();
          case 404:
            return NotFoundError();
          case 409:
            return ConflictError();
          case 500:
            if(error.response!.data == null &&
                error.response!.data["data"] == null &&
                error.response!.data["message"] == null)
              {
                return InternalServerError();
              }
             else
               return ErrorMessageModel<E>.fromMap(error.response!.data);
             break;
          default:
            return HttpError();
        }
      
    } else if (error.type == DioErrorType.connectTimeout ||
        error.type == DioErrorType.sendTimeout ||
        error.type == DioErrorType.receiveTimeout) {
      return TimeoutError();
    } else if (error.type == DioErrorType.cancel) {
      return CancelError();
    } else
      return UnknownError();
  }
}