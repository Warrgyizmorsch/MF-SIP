import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../services/session_manager.dart';
import '../utils/api/api_result.dart';
import '../exceptions/app_exceptions.dart';
import '../utils/helper/helpers.dart';
import 'base_api_service.dart';

class NetworkServicesApi implements BaseApiServices {
  final client = http.Client();

  @override
  Future<http.Response> getApi(
      String url, {
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
        Object? body,
      }) async {
    return await _sendRequest((requestHeaders) async {
      Uri uri = Uri.parse(url);
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParameters);
      }

      var request = http.Request("GET", uri);
      request.headers.addAll(requestHeaders);
      if (body != null) {
        request.body = body is String ? body : jsonEncode(body);
        request.headers.putIfAbsent('Content-Type', () => 'application/json');
      }

      var streamedResponse = await client.send(request);
      return await http.Response.fromStream(streamedResponse);
    });
  }

  @override
  Future<http.Response> postApi(String url, data) async {
    return await _sendRequest((headers) {
      return client.post(
        Uri.parse(url),
        headers: headers,
        body: _safeJsonEncode(data),
      );
    });
  }

  @override
  Future<http.Response> postFormData(String url, Map<String, dynamic> data) async {
    final formHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    String encodeValue(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is int || value is double || value is bool) return value.toString();
      if (value is List || value is Map) return jsonEncode(value); // nested objects/lists as JSON string
      return value.toString();
    }

    final formBody = data.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(encodeValue(e.value))}')
        .join('&');

    createLog("[API] POST FormData to $url");
    createLog("[API] Headers: $formHeaders");
    createLog("[API] Body: $formBody");

    return await _sendRequest(
      timeoutSeconds: 60,
          (headers) => client.post(
        Uri.parse(url),
        headers: headers,
        body: formBody,
        encoding: Encoding.getByName('utf-8'),
      ),
      customHeaders: formHeaders,
    );
  }

  @override
  Future<http.Response> postMultipart(
      String url,
      Map<String, String> fields,
      List<Uint8List> files,
      List<String> fileNames,
      ) async {

    final multipartHeaders = {
      'Content-Type': 'multipart/form-data',
    };

    createLog("[API] POST Multipart to $url");
    createLog("[API] Headers: $multipartHeaders");
    createLog("[API] Fields: $fields");
    createLog("[API] File count: ${files.length}");

    return await _sendRequest(
          (headers) async {
        final request = http.MultipartRequest('POST', Uri.parse(url));

        // Merge headers (base headers + custom headers)
        request.headers.addAll({...headers, ...multipartHeaders});

        // Add form fields
        request.fields.addAll(fields);

        // Add files (ANY type)
        for (int i = 0; i < files.length; i++) {
          final fileName = fileNames[i];

          // Detect MIME
          final mime = lookupMimeType(fileName) ?? 'application/octet-stream';

          final mediaType = http.MediaType.parse(mime);

          request.files.add(
            http.MultipartFile.fromBytes(
              'attachments',
              files[i],
              filename: fileName,
              contentType: mediaType,
            ),
          );

          createLog("[API] Added file: $fileName ($mime)");
        }

        // Send and convert the streamed response
        final streamedResponse = await request.send();
        return await http.Response.fromStream(streamedResponse);
      },
      customHeaders: multipartHeaders,
    );
  }




  @override
  Future<http.Response> putApi(String url, data) async {
    return await _sendRequest((headers) {
      return client.put(
        Uri.parse(url),
        headers: headers,
        body: _safeJsonEncode(data),
      );
    });
  }

  @override
  Future<http.Response> patchApi(String url, data) async {
    return await _sendRequest((headers) {
      return client.patch(
        Uri.parse(url),
        headers: headers,
        body: _safeJsonEncode(data),
      );
    });
  }

  @override
  Future<http.Response> deleteApi(String url, data) async {
    return await _sendRequest((headers) {
      return client.delete(
        Uri.parse(url),
        headers: headers,
        body: _safeJsonEncode(data),
      );
    });
  }

  Future<http.StreamedResponse> uploadImageToS3(String uploadUrl, File imageFile) async {
    try {
      final request = http.MultipartRequest('PUT', Uri.parse(uploadUrl))
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        final responseBody = await response.stream.bytesToString();
        createLog("S3 Upload Error Response Body: $responseBody");
        throw FetchDataException(
          'Error uploading image to S3: ${response.statusCode}\n$responseBody',
        );
      }
    } catch (e) {
      throw FetchDataException('Exception during image upload: $e');
    }
  }
  Future<http.Response> _sendRequest(
      Future<http.Response> Function(Map<String, String>) requestFn,
      {Map<String, String>? customHeaders,
        // NEW: Optional parameter for timeout duration, defaults to 30 seconds
        int timeoutSeconds = 30}) async {
    try {
      final accessToken = SessionManager.instance.jwtAccessToken;
      final packageInfo = await PackageInfo.fromPlatform();

      // Default headers
      final defaultHeaders = <String, String>{
        'Content-Type': 'application/json',
        'app': 'true',
        'platform' : Platform.isIOS ? "IOS App" : "Android App",
        'version' : '${packageInfo.version}+${packageInfo.buildNumber}',
        if (accessToken != null && accessToken.isNotEmpty)
          'Authorization': 'Bearer $accessToken',
      };

      // Merge with custom headers (customHeaders take precedence)
      final headers = {...defaultHeaders, if (customHeaders != null) ...customHeaders};

      createLog("[API] Request Headers: $headers");
      createLog("[API] Timeout set to: $timeoutSeconds seconds");

      // APPLYING THE CONFIGURABLE TIMEOUT DURATION
      http.Response response = await requestFn(headers)
          .timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      }

      // Explicitly returning response for specific error codes for caller handling
      if (response.statusCode == 404 ||
          response.statusCode == 400 ||
          response.statusCode == 500) {
        return response;
      }

      createLog("[API] Response Status: ${response.statusCode}");
      createLog("[API] Response Body: ${response.body}");

      if (response.statusCode == 403) {
        throw UnauthorizedException('Permission denied: ${response.body}');
      }

      throw FetchDataException(
          'Error with status code: ${response.statusCode}\n${response.body}');
    } on SocketException {
      throw NoInternetException("Please check your Internet Connection");
    } on TimeoutException {
      // This now catches the timeout from the .timeout() call
      throw RequestTimeoutException("Request TimedOut after $timeoutSeconds seconds");
    } on AuthenticationFailedException {
      rethrow;
    } catch (e, stackTrace) {
      createLog("[API] Unexpected exception: $e\n$stackTrace");
      throw FetchDataException('Unexpected error: ${e.toString()}');
    }
  }

// --- EXAMPLE USAGE ---

  Future<void> main() async {
    // 1. Example using the default 30-second timeout
    try {
      await _sendRequest((headers) async {
        // Simulate a fast, successful request
        return http.Response('{"status": "ok"}', 200);
      });
      print("\n--- Request 1 (Default Timeout) Successful ---");
    } catch (e) {
      print("Request 1 Failed: $e");
    }

    // 2. Example setting a custom 10-second timeout
    try {
      await _sendRequest(
            (headers) async {
          // Simulate a request that is fast
          return http.Response('{"status": "custom timeout applied"}', 200);
        },
        timeoutSeconds: 10,
      );
      print("\n--- Request 2 (Custom 10s Timeout) Successful ---");
    } catch (e) {
      print("Request 2 Failed: $e");
    }
  }



  String _safeJsonEncode(dynamic data) {
    return jsonEncode(data, toEncodable: (nonEncodable) {
      if (nonEncodable is Result) return nonEncodable.toString();
      return nonEncodable.toString();
    });
  }
}
