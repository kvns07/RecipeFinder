import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'RecipeDetailedPAge.dart';
import 'dart:convert';
class RecipeSearchPage extends StatefulWidget {
  @override
  _RecipeSearchPageState createState() => _RecipeSearchPageState();
}

class _RecipeSearchPageState extends State<RecipeSearchPage> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final apiKey = '73e6b2270ac14f1799190b3d41ccd7a9';
    final url = 'https://api.spoonacular.com/recipes/findByIngredients?ingredients=apples&apiKey=$apiKey'; // Replace with your API endpoint
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final jsonData = json.decode(response.body);
        // print(jsonData);
        setState(() {
          data = jsonData;
          print(data);// Assuming the API response contains a 'results' field with the list of elements
        });
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for recipes by ingredients...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                // Implement search functionality
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
              final item = data[index];
                return ListTile(
                  title: Text(item['title']), // Assuming each item has a 'name' field
                  subtitle: Text(item['title']),
                  leading: SizedBox(
                      height: 100.0,
                      width: 100.0, // fixed width and height
                      child: Image.network(item['image'])
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Handle button pres
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecipeDetailPage(data,index)),
                      );
                      // return
                    },
                    child: Text(
                        'Recipe',
                        style: TextStyle(fontSize: 10),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

