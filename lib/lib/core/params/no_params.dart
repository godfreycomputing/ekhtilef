import 'package:dio/dio.dart';

import 'base_params.dart';

abstract class NoParams extends BaseParams {
  NoParams({CancelToken? cancelToken}) : super(cancelToken: cancelToken);
}
