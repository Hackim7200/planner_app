import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, String>> getPrayerTimes(
      String city, String country) async {
    final String url =
        'https://api.aladhan.com/v1/timingsByCity?city=$city&country=$country&method=4&adjustment=1';

    final response =
        await http.get(Uri.parse(url), headers: {'accept': 'application/json'});

    if (response.statusCode == 200) {
      // Parse the JSON response
      var jsonResponse = jsonDecode(response.body);

      // Check if 'data' and 'timings' are present in the response
      if (jsonResponse['data'] != null &&
          jsonResponse['data']['timings'] != null) {
        // Extract prayer timings and return them as a Map<String, String>
        Map<String, String> timings =
            Map<String, String>.from(jsonResponse['data']['timings']);
        return timings;
      } else {
        throw Exception('Prayer timings not found in the response');
      }
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
}
