import 'package:flutter/material.dart';
class RecipeDetailPage extends StatelessWidget {
  List<dynamic> data = [];
  List<Map<String,dynamic>> mI=[];
  int index;

  RecipeDetailPage(this.data, this.index);
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data2=data[index];
    // print(data2["missedIngredients"]);
    print("ha");
    for (var entry in data2.entries) {
      final key = entry.key;
      final value = entry.value;
      // print("$key,  ,$value");
      if(key=="missedIngredients"||key=="usedIngredients"||key=="unusedIngredients"){
        // print()
        for(var ent in value) mI.add(ent);
      }
    }
    print(mI);
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details'),
      ),
      body: Column(
        children:[
          Expanded(
              // child:ListView(
              //     children: data2.entries.map((entry) {
              //       final key = entry.key;
              //       final value = entry.value;
              //       print("$key,  ,$value");
              //       if(key=="missedIngredients") return ListTile(title:Text(value[0]['id']));
              //       else return ListTile(title:Text(" "));
              //     }).toList(),
              // ),
            child: ListView.builder(
              itemCount: mI.length,
              itemBuilder: (context, ind) {
                final item = mI[ind];
                print(item);
                return ListTile(
                  title: Text("Ingredient: ${item['original']}"
                      "\nAmount is ${item["amount"].toString()} "
                      "${item['unit']}"
                      ""), // Assuming each item has a 'name' field
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
        ]
      ),
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
