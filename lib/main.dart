import "dart:async";

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

main() {
  runApp(new MaterialApp(
    home: new HomePage(),
  ));

}

class HomePage extends StatefulWidget{
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage>{

  Future<String>getData() async{
    http.Response response = await http.get(
      "https://www.food2fork.com/api/search",
      headers: {
        "key": "8c3c655ad410ef1edbbfb9622eec71a5",
        "q": "Chicken Breast, Salt, Pepper",
        "sort": "r"
      }
    );

    print(response.body);
  }
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: new Center(
        child: new RaisedButton(
          child: new Text("Test Api"),
          onPressed: getData,
        ),
      ),
    );
  }
}