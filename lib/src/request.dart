import 'dart:convert';

import 'package:typed_http/src/http_method.dart';

class Request<T> {
  const Request(
    this.method,
    this.url,
    this.encoding,
    this.headers,
    this.body,
  );

  final HttpMethod method;

  final Uri url;

  final Encoding encoding;

  final Map<String, String> headers;

  final T body;
}
