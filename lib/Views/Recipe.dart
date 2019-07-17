export 'package:rerecipe_app/Views/Recipe.dart';
class Recipe{
  String publisher;
  String title;
  String sourceUrl;
  String recipeID;
  String imageUrl;
  double rank;

  Recipe(this.publisher, this.title, this.sourceUrl, this.recipeID, this.imageUrl, this.rank);

}