import 'package:flutter/material.dart';
import 'Recipe.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipesView extends StatefulWidget {
  List<Recipe> _recipes = [
    new Recipe(
        "Closet Cooking",
        "Jalapeno Popper Grilled Cheese Sandwich",
        "http://www.closetcooking.com/2011/04/jalapeno-popper-grilled-cheese-sandwich.html",
        "35382",
        "http://static.food2fork.com/Jalapeno2BPopper2BGrilled2BCheese2BSandwich2B12B500fd186186.jpg",
        100),
  ];

  RecipesView(this._recipes);

  @override
  State<StatefulWidget> createState() {
    return _RecipesViewState();
  }
}

// Private class
class _RecipesViewState extends State<RecipesView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: widget._recipes
            .map((recipe) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.blueAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      recipe.title,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textScaleFactor: 1.2,
                    ),
                    Container(
                      margin: EdgeInsets.all(2.0),
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          _launchURL(recipe.sourceUrl);
                        },
                        child: Text(
                          "Cook This",
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                          textScaleFactor: 1.1,
                        ),
                      ),
                    )
                  ],
                )))
            .toList());
  }

  void _launchURL(String url) async {
    String linkUrl = url;
    if (await canLaunch(linkUrl)) {
      await launch(linkUrl);
    } else {
      throw 'Could not launch $linkUrl';
    }
  }
}
