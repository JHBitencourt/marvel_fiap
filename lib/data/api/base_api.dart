import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' show md5;

const baseUrl = 'https://gateway.marvel.com/';
const charactersPath = 'v1/public/characters';

const _accept = 'Accept';
const _contentType = 'Content-Type';
const _applicationJson = 'application/json';
const _timeoutSeconds = 60;
const _publicMarvelKey = 'bbe882c1183450aac4b90b6b09929c3f';

/// The private key is hardcoded here since this is an example, but it
/// shouldn't be here in a production environment
const _privateMarvelKey = '';

class BaseApi {
  Future<Map<String, String>> _buildHeaders() async {
    return {
      _contentType: _applicationJson,
      _accept: _applicationJson,
    };
  }

  Future<dynamic> get(String url) async {
    final headers = await _buildHeaders();

    final authorizedUrl = _addAuthorization(url);
    final response = await http
        .get(
          Uri.parse(authorizedUrl),
          headers: headers,
        )
        .timeout(
          const Duration(seconds: _timeoutSeconds),
          onTimeout: _onTimeout,
        );

    return _responseRequest(response);
  }

  String _addAuthorization(String url) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    final bytes = utf8.encode('$timestamp$_privateMarvelKey$_publicMarvelKey');
    final hash = md5.convert(bytes);

    return '$url&ts=$timestamp&apikey=$_publicMarvelKey&hash=$hash';
  }

  Future<dynamic> _responseRequest(http.Response response,
      {bool bytes = false}) {
    switch (response.statusCode) {
      case 200:
        if (bytes) {
          return Future.value(response.bodyBytes);
        }

        dynamic responseJson;
        if (response.body.isNotEmpty) {
          responseJson = json.decode(
            utf8.decode(response.bodyBytes),
          );
        }

        return Future.value(responseJson);
      default:
        _logResponse(response);
        throw const HttpException('Status different than 200');
    }
  }

  void _logResponse(http.Response response) {
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    debugPrint(response.headers.toString());
    debugPrint(response.request.toString());
  }

  Future<http.Response> _onTimeout() {
    throw TimeoutException('Timeout during request');
  }
}
