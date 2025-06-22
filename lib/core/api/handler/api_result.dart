abstract class ApiResult {}

class ApiErrorResult extends ApiResult implements Exception {
  final int errorCode;
  final String originalErrorMessage;

  ApiErrorResult({
    required this.errorCode,
    required this.originalErrorMessage,
  });
}

class ApiDataResult<T> extends ApiResult {
  final T data;

  ApiDataResult({required this.data});
}
