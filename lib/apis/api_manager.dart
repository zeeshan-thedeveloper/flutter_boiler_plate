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
    try {
      final response = await http.Client().post(
        Uri.parse('${Constants.baseUrl}/$endpoint'), // Use the baseUrl constant
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return {'success': true, 'data': data};
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