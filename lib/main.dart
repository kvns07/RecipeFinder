import 'package:flutter/material.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';

import 'pages/RecipePage.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InternetWidget(
      offline: FullScreenWidget(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Recipe Search'),
          ),
          body: const Center(child: Text('No Internet')),
        ),
      ),
      // ignore: avoid_print
      whenOffline: () => print('No Internet'),
      // ignore: avoid_print
      whenOnline: () => print('Connected to internet'),
      loadingWidget: const Center(child: Text('Loading')),
      //offline: const Center(child: Text('No Internet')),
      // return ;
      online: MaterialApp(
          title: 'Recipe Search',
          theme: ThemeData(
          primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: RecipeSearchPage(),
      ),
    );
  }

  }

