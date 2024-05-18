abstract class ResultModel<T extends Object> {}

class ResultSuccess<T extends Object> extends ResultModel<T> {
  final T data;

  ResultSuccess({required this.data});
}

class ResultFailure<T extends Object> extends ResultModel<T> {
  final Exception exception;
  final T? data;

  ResultFailure(this.exception, {this.data});
}
