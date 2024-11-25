import 'dart:convert';  // Import json
import 'package:http/http.dart' as http;  // Import http

class ApiService {
  final String apiKey = "83fa942b40204b3190833126242411";
  final String baseUrl = "https://api.weatherapi.com/v1";

  Future<Map<String, dynamic>> getWeather(String city) async {
    final url = '$baseUrl/current.json?key=$apiKey&q=$city';
    print("Requesting: $url");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Response: ${response.body}");
      return json.decode(response.body);
    } else {
      print("Error ${response.statusCode}: ${response.body}");
      throw Exception('Failed to load weather');
    }
  }
}
