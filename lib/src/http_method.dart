// Copyright 2023 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

enum HttpMethod {
  /// `GET`
  get('GET'),

  /// `POST`
  post('POST'),

  /// `DELETE`
  delete('DELETE'),

  /// `PUT`
  put('PUT'),

  /// `PATCH`
  patch('PATCH');

  /// The value.
  final String value;

  /// Returns the http method associated with [value].
  static HttpMethod valueOf(final String value) {
    for (final method in values) {
      if (method.value == value) {
        return method;
      }
    }

    throw UnsupportedError('Unsupported value [$value].');
  }

  const HttpMethod(this.value);

  bool _checkMethodValue(final HttpMethod method) => value == method.value;

  bool get isGet => _checkMethodValue(HttpMethod.get);
  bool get isPost => _checkMethodValue(HttpMethod.post);
  bool get isDelete => _checkMethodValue(HttpMethod.delete);
  bool get isPut => _checkMethodValue(HttpMethod.put);
  bool get isPatch => _checkMethodValue(HttpMethod.patch);
}
