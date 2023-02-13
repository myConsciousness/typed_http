import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:typed_http/src/http_method.dart';
import 'package:typed_http/src/response.dart';
import 'package:typed_http/src/transformer.dart';

typedef JsonResolver<T> = T Function(Map<String, Object?> json);

abstract class HttpClient {
  /// Returns the new instance of [HttpClient].
  factory HttpClient() => _HttpClient();

  /// Sends GET request.
  Future<Response<T?>> get<T>(
    final Uri url, {
    Map<String, String>? headers,
    JsonResolver<T>? resolver,
    Duration timeout = const Duration(seconds: 10),
  });

  /// Sends GET request for multiple entities.
  Future<Response<List<T?>?>> getEntities<T>(
    final Uri url, {
    Map<String, String>? headers,
    required JsonResolver<T> resolver,
    Duration timeout = const Duration(seconds: 10),
  });

  Future<http.StreamedResponse> stream(
    final Uri url, {
    Map<String, String>? headers = const {},
    Duration timeout = const Duration(seconds: 10),
  });

  /// Sends POST request.
  Future<Response<T?>> post<T>(
    final Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    JsonResolver<T>? resolver,
    Duration timeout = const Duration(seconds: 10),
  });

  /// Sends DELETE request.
  Future<Response<T?>> delete<T>(
    final Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    JsonResolver<T>? resolver,
    Duration timeout = const Duration(seconds: 10),
  });

  /// Sends PUT request.
  Future<Response<T?>> put<T>(
    final Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    JsonResolver<T>? resolver,
    Duration timeout = const Duration(seconds: 10),
  });

  /// Sends PATCH request.
  Future<Response<T?>> patch<T>(
    final Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    JsonResolver<T>? resolver,
    Duration timeout = const Duration(seconds: 10),
  });

  Future<Response<T?>> multipart<T>(
    HttpMethod method,
    Uri url, {
    required List<http.MultipartFile> files,
    Map<String, String>? headers,
    JsonResolver<T>? resolver,
    Duration timeout = const Duration(seconds: 10),
  });
}

class _HttpClient implements HttpClient {
  /// Returns the new instance of [_HttpClient].
  const _HttpClient();

  @override
  Future<Response<T?>> get<T>(
    final Uri url, {
    Map<String, String>? headers,
    JsonResolver<T>? resolver,
    Duration timeout = const Duration(seconds: 10),
  }) async =>
      transform<T>(
        await http
            .get(
              url,
              headers: headers,
            )
            .timeout(timeout),
        resolver,
      );

  @override
  Future<Response<List<T?>?>> getEntities<T>(
    final Uri url, {
    Map<String, String>? headers,
    required JsonResolver<T> resolver,
    Duration timeout = const Duration(seconds: 10),
  }) async =>
      transformList<T>(
        await http
            .get(
              url,
              headers: headers,
            )
            .timeout(timeout),
        resolver,
      );

  @override
  Future<http.StreamedResponse> stream(
    final Uri url, {
    Map<String, String>? headers = const {},
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final request = http.Request(HttpMethod.get.value, url);
    request.headers.addAll(headers ?? {});

    return await request.send().timeout(timeout);
  }

  @override
  Future<Response<T?>> post<T>(
    final Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    JsonResolver<T>? resolver,
    Duration timeout = const Duration(seconds: 10),
  }) async =>
      transform(
        await http
            .post(
              url,
              headers: headers,
              body: body,
              encoding: encoding,
            )
            .timeout(timeout),
        resolver,
      );

  @override
  Future<Response<T?>> delete<T>(
    final Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    JsonResolver<T>? resolver,
    Duration timeout = const Duration(seconds: 10),
  }) async =>
      transform(
        await http
            .delete(
              url,
              headers: headers,
              body: body,
              encoding: encoding,
            )
            .timeout(timeout),
        resolver,
      );

  @override
  Future<Response<T?>> put<T>(
    final Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    JsonResolver<T>? resolver,
    Duration timeout = const Duration(seconds: 10),
  }) async =>
      transform(
        await http
            .put(
              url,
              headers: headers,
              body: body,
              encoding: encoding,
            )
            .timeout(timeout),
        resolver,
      );

  @override
  Future<Response<T?>> patch<T>(
    final Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    JsonResolver<T>? resolver,
    Duration timeout = const Duration(seconds: 10),
  }) async =>
      transform(
        await http
            .patch(
              url,
              headers: headers,
              body: body,
              encoding: encoding,
            )
            .timeout(timeout),
        resolver,
      );

  @override
  Future<Response<T?>> multipart<T>(
    HttpMethod method,
    Uri url, {
    required List<http.MultipartFile> files,
    Map<String, String>? fields,
    Map<String, String>? headers,
    JsonResolver<T>? resolver,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (method.isGet || method.isDelete) {
      throw ArgumentError.value(method, 'method', 'Unsupported HTTP method.');
    }

    final request = http.MultipartRequest(method.value, url);
    request.files.addAll(files);
    request.fields.addAll(fields ?? {});
    request.headers.addAll(headers ?? {});

    return transform(
      await http.Response.fromStream(
        await http.MultipartRequest(
          method.value,
          url,
        ).send(),
      ).timeout(timeout),
      resolver,
    );
  }
}
