import 'package:flutter/material.dart';
// RecipePage
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:permission_handler/permission_handler.dart';

class RecipeDetailPage extends StatefulWidget {
  List<dynamic> data = [];
  List<dynamic> summary = [];
  List<Map<String,dynamic>> mI=[];
  int index;
  RecipeDetailPage(this.data, this.index,this.summary);
  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}
class _RecipeDetailPageState extends State<RecipeDetailPage> {

  // Bool firstUp=true;
  Map<String,dynamic> sdata={'summary':"Loading"};
  @override
  Widget build(BuildContext context) {
    List<dynamic> data =widget.data;
    List<dynamic> summary = widget.summary;
    List<Map<String,dynamic>> mI1=widget.mI;
    int index=widget.index;

  // print(data[index][id])

    int id=data[index]['id'];
    print(id);
    final apiKey = '668bd1a9195b45c9be73281f4855f975';
    Future<void> fetchData() async {

      final url = 'https://api.spoonacular.com/recipes/$id/summary?apiKey=$apiKey'; // Replace with your API endpoint
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          // If the server returns a 200 OK response, parse the JSON
          final jsonData = json.decode(response.body);
          // print(jsonData);
          setState(() {
            sdata = jsonData;
            print(sdata);// Assuming the API response contains a 'results' field with the list of elements
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
    setState((){
      fetchData();
    });
    Future<void> savePdf() async {
      // Sample JSON data
      List<Map<String, dynamic>> tmp=[];
      tmp.add({'summary':sdata['summary']});
      // final permissionStatus = await Permission.storage.request();
      // if (permissionStatus.isDenied) {
      //   await Permission.storage.request();
      //   if (permissionStatus.isDenied) {
      //     await openAppSettings();
      //   }
      // } else if (permissionStatus.isPermanentlyDenied) {
      //   await openAppSettings();
      // }
      // Convert JSON data to PDF content
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text(tmp.toString()),
            );
          },
        ),
      );

      // Save PDF file locally
      final file = File('Recipe1.pdf');
      await file.writeAsBytes(await pdf.save());
    };
    Future _getStoragePermission() async {
      if (await Permission.storage.request().isGranted) {
        await savePdf();
        // setState(() {
        //   permissionGranted = true;
        // });
      } else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.storage.request().isDenied) {
        // setState(() {
        //   permissionGranted = false;
        // });
        }
        else{
          print("errr"
              "rrr"
              "rr"
              "r"
              ""
              "r");

      }
    }

    Map<String, dynamic> data2=data[index];
    // print(data2["missedIngredients"]);
    print(index);
    // print(summary);
    // print();
    // orint
    for (var entry in data2.entries) {
      final key = entry.key;
      final value = entry.value;
      // print("$key,  ,$value");
      if(key=="missedIngredients"||key=="usedIngredients"||key=="unusedIngredients"){
        // print()
        for(var ent in value) mI1.add(ent);
      }
    }
    // print(mI);
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _getStoragePermission;
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Recipe Saved'),
                      content: Text('The PDF file has been saved as Recipe1.pdf'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Save Recipe PDF'),
            ),
          ]
      ),
      body: SingleChildScrollView(

      child:Column(
        children:[
          SizedBox(
            // width: 320,
            // height: 10,
            child: Container(
              // color: Colors.blue, // Set background color
              child: Center(
                child: Text(
                  'Summary',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(),
          // ),
          // Expanded(
          //   flex:4,
          SizedBox(
              width: 320,
              // height: 10,
              child: Container(
                // summary[0]['8']['summary']

                // color: Colors.blue, // Set background color
                child: Center(
                  child:Html(
                    data: sdata['summary'],
                    style: {
                      'b': Style(color: Colors.black,fontWeight: FontWeight.bold),
                    },
                  ),
                ),
              )
          ),
          SizedBox(
            width: 200,
            height: 50,
            child: Container(
              // color: Colors.blue, // Set background color
              child: Center(
                child: Text(
                  'Ingredients',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(
            child:ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: mI1.length,
              itemBuilder: (context, ind) {
                final item = mI1[ind];
                print(item);
                return ListTile(
                  title: Text("Ingredient: ${item['original']}"
                      "\nAmount is ${item["amount"].toString()} "
                      "${item['unit']}"
                      "",style:TextStyle(fontSize:13)), // Assuming each item has a 'name' field
                  // subtitle: Text(item['id']),
                  leading: SizedBox(
                      height: 100.0,
                      width: 100.0, // fixed width and height
                      child: Image.network(item['image'])
                  ),
                );
              },
            ),
          )
          // )
        ]
      ),)
    );
  }

}

// SingleChildScrollView(
// padding: EdgeInsets.all(8.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// 'missedIngredients',
// style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// ),
// // List of ingredients
// Text(
// 'Cooking Instructions:',
// style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// ),
// // Cooking instructions
// Text(
// 'Nutritional Information:',
// style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// ),
// // Nutritional information
// ],
// ),
// )
