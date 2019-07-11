export 'package:rerecipe_app/Views/Recipe.dart';
class Recipe{
  String name;
  String imgPath;
  String description;
  int timeToMake;


  Recipe(String name, String path, String description, int timeToMake){
    this.name = name;
    this.imgPath = path;
    this.description = description;
    this.timeToMake = timeToMake;
  }

}