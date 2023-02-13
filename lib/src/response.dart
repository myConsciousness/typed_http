import 'package:typed_http/src/http_status.dart';

class Response<T> {
  const Response({
    required this.status,
    this.body,
  });

  final HttpStatus status;

  final T? body;

  /// Returns true if this response has [body], otherwise false.
  bool get hasData => body != null;
}
