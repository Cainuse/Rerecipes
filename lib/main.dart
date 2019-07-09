import 'package:flutter/material.dart';
import 'Recipe.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

// Private class
class _MyAppState extends State<MyApp> {
  List<Recipe> _recipes = [
    new Recipe('Vietnamese Pho Noodles', 'assets/pho.jpg', '', 1),
    new Recipe('Egg Scallion Fried Rice', 'assets/friedrice.jpg', '', 20)
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          // White background
          appBar: AppBar(
            // Blue app bar
            title: Text('Rerecipes'), //Text
          ),
          body: Column(
            children: _recipes
                .map((recipe) => Card(
                        child: Column(
                      children: <Widget>[
                        Image.asset(recipe.imgPath),
                        Text(
                          recipe.name,
                          textScaleFactor: 2,
                        ),
                        Container(
                          margin: EdgeInsets.all(2.0),
                          child: RaisedButton(
                            onPressed: () {},
                            child: Text("See More"),
                          ),
                        )
                      ],
                    )))
                .toList(),
          )),
    );
  }
}
