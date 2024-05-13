import 'package:http/http.dart' as http;

Future<void> fetchData() async {
  final url = 'https://api.example.com/data'; // Replace with your API endpoint
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final jsonData = json.decode(response.body);
      // Process the JSON data
      print(jsonData);
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load data');
    }
  } catch (e) {
    // Handle errors
    print('Error: $e');
  }
}
