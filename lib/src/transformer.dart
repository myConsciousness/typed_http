import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:typed_http/src/http.dart';
import 'package:typed_http/src/http_status.dart';

import 'package:typed_http/src/response.dart';

Response<T?> transform<T>(
  final http.Response response,
  JsonResolver<T>? resolver,
) {
  if (response.body.isEmpty) {
    return Response(
      status: HttpStatus.codeOf(response.statusCode),
    );
  }

  if ((T == Map || T == List) && resolver == null) {
    return Response(
      status: HttpStatus.codeOf(response.statusCode),
      body: jsonDecode(response.body),
    );
  }

  if (resolver == null) {
    return Response(
      status: HttpStatus.codeOf(response.statusCode),
      body: response.body as T,
    );
  }

  return Response(
    status: HttpStatus.codeOf(response.statusCode),
    body: response.body.isNotEmpty
        ? resolver.call(jsonDecode(response.body))
        : null,
  );
}

Response<List<T?>?> transformList<T>(
  final http.Response response,
  final JsonResolver<T> resolver,
) {
  if (response.body.isEmpty) {
    return Response(
      status: HttpStatus.codeOf(response.statusCode),
    );
  }

  return Response(
    status: HttpStatus.codeOf(response.statusCode),
    body: jsonDecode(response.body).map<T>((e) => resolver.call(e)).toList(),
  );
}
