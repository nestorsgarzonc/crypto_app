import 'package:crypto_app/core/external/api_response.dart';
import 'package:crypto_app/core/failure/failure.dart';

class ApiException extends Failure {
  ApiException(this.response) : super(generalError);
  final ApiResponse response;

  static const generalError = 'Ha ocurrido un error';

  String get error {
    try {
      final resMap = response.responseMap;
      final error = resMap['msg'];
      if (error is! String) return generalError;
      return error;
    } catch (e) {
      return generalError;
    }
  }

  @override
  String toString() => error;

  @override
  bool operator ==(covariant ApiException other) {
    if (identical(this, other)) return true;

    return other.response == response;
  }

  @override
  int get hashCode => response.hashCode;
}
