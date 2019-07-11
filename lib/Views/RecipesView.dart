import 'package:flutter/material.dart';
import 'Recipe.dart';

class RecipesView extends StatefulWidget {
  RecipesView();
  @override
  State<StatefulWidget> createState() {
    return _RecipesViewState();
  }
}

// Private class
class _RecipesViewState extends State<RecipesView> {
  List<Recipe> _recipes = [
    new Recipe('Vietnamese Pho Noodles', 'assets/pho.jpg', '', 1),
    new Recipe('Egg Scallion Fried Rice', 'assets/friedrice.jpg', '', 20)
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
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
                .toList());
  }
}
