abstract class AppCubitStatus {}

class AppCubitInitial extends AppCubitStatus {}

class AppCubitLoading extends AppCubitStatus {}

class AppCubitSuccess extends AppCubitStatus {
  final String message;
  final int code;

  AppCubitSuccess({this.message = '', this.code = 452});
}

class AppCubitError extends AppCubitStatus {
  final String message;

  AppCubitError({required this.message});
}

class AppCubitNoInternet extends AppCubitStatus {}

class AppCubitNoData extends AppCubitStatus {}

class AppCubitNoMoreData extends AppCubitStatus {}

class AppCubitNoMoreDataWithMessage extends AppCubitStatus {
  final String message;

  AppCubitNoMoreDataWithMessage(this.message);
}
