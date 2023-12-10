import 'dart:convert';
import 'package:flutter_boiler_plate/utils/constants.dart';
import 'package:http/http.dart' as http;

class ApiManager {
  static Future<Map<String, dynamic>> callApi({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    late http.Response response;
    final uri = Uri.parse('${Constants.baseUrl}/$endpoint');

    try {
      if (method == 'GET') {
        response = await http.get(uri, headers: headers);
      } else if (method == 'POST') {
        response = await http.post(uri,
            headers: headers, body: body != null ? jsonEncode(body) : null);
      } else if (method == 'PUT') {
        response = await http.put(uri,
            headers: headers, body: body != null ? jsonEncode(body) : null);
      } else if (method == 'DELETE') {
        response = await http.delete(uri, headers: headers);
      } else {
        // Handle other HTTP methods as needed
        return {
          'success': false,
          'message': 'Unsupported HTTP method: $method',
        };
      }

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data is Map<String, dynamic> || data is List<dynamic>) {
          return {'success': true, 'data': data};
        } else {
          return {
            'success': false,
            'message': 'Error: Unexpected data structure',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Error: ${response.reasonPhrase}',
        };
      }
    } catch (error) {
      return {'success': false, 'message': 'Error: $error'};
    }
  }
}
