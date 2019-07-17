import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:rerecipe_app/Views/Misc/IngredientsView.dart';
import 'package:rerecipe_app/Views/RecipesView.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:rerecipe_app/Views/Recipe.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;
  String _currentLocale = "";
  String resultText = "";
  final navigatorKey = GlobalKey<NavigatorState>();
  Set<String> items = new Set();
  String inputItem = "";
  TabController _tabController;
  List<Recipe> recipes =[];

  final List<Tab> myTabs = <Tab>[
    Tab(
      text: "Fridge",
      icon: Icon(Icons.bubble_chart),
    ),
    Tab(
      text: "Recipes",
      icon: Icon(Icons.lightbulb_outline),
    ),
    Tab(
      text: "Shop",
      icon: Icon(Icons.shopping_cart),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
    _tabController.addListener(_handleTabChange);
    initSpeechRecognizer();
  }

  // Initializes the speech recognition plugin
  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    //Handler of when the speech recognition service is available
    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result),
    );
    // handle device current locale detection
    _speechRecognition.setCurrentLocaleHandler(
        (String locale) => setState(() => _currentLocale = locale));
    //Handler of when the microphone is listening for user input
    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );
    //Handler of when the microphone has picked up user input
    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultText = speech),
    );
    //Handler of when the microphone is turned off and has stopped listening
    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() {
            _isListening = false;
            resultText.split(' ').forEach((item) {
              if (item.length > 0) {
                items.add(item);
              }
            });
          }),
    );
    //Activate the speech recognition
    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
        if ( _tabController.index == 1) {
           getRecipes();
        }
    }
  }

  Future<String> getRecipes() async{
    String url = "https://www.food2fork.com/api/search?key=8c3c655ad410ef1edbbfb9622eec71a5";
    String ingredients = items.join(",").replaceAll(new RegExp(r"\s+\b|\b\s"), "%20");
    print(ingredients);
    int page = 1;
    print(url+"&q="+ingredients+"&page="+page.toString());
    Response response = await get(
      url+"&q="+ingredients+"&page="+page.toString()
        ,
//        headers: {
//          "key": "8c3c655ad410ef1edbbfb9622eec71a5",
////          "q": "Chicken Breast, Salt, Pepper",
////          "sort": "r"
//        }
    );
    parseRecipes(json.decode(response.body));
  }

  void parseRecipes(Map<String, dynamic> json){
    setState(() {
      List<dynamic> listOfRecipes = json['recipes'] as List;
      listOfRecipes.forEach((recipe){
        Recipe recipeObject = Recipe(recipe['publisher'] as String, recipe['title'] as String, recipe['source_url'] as String, recipe['recipe_id'] as String, recipe['image_url'] as String, recipe['social_rank'] as double);
        recipes.add(recipeObject);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text(
                    'Revercipe',
                    textScaleFactor: 1.2,
                  ),
                  backgroundColor: Colors.blueAccent,
                  bottom: TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.white,
                    controller: _tabController,
                    tabs: myTabs,
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        onPressed: () {})
                  ],
                ),
                body: TabBarView(
                  controller: _tabController,
                    children: [
                  Scaffold(
                    backgroundColor: Colors.white,
                    bottomNavigationBar: BottomNavigationBar(
                      unselectedItemColor: Colors.white70,
                      backgroundColor: Colors.blueAccent,
                      selectedItemColor: Colors.white,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.autorenew),
                          title: Text("Clear"),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.keyboard),
                          title: Text("Add"),
                        )
                      ],
                      onTap: _onItemTapped,
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        if (_isAvailable && !_isListening) {
                          _speechRecognition
                              .listen(locale: _currentLocale)
                              .then((result) => print('$result'));
                        }
                      },
                      child: Icon(Icons.mic),
                      backgroundColor: Colors.green,

                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Wrap(
                            spacing: 7.0,
                            children: items
                                .map((item) => new IngredientView(
                                    item, Icons.fastfood, items, this))
                                .toList(),
                          ),
                        ),

//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          crossAxisAlignment: CrossAxisAlignment.end,
//                          children: <Widget>[
//                            Expanded(
//                              child: Container(
//                                  padding: EdgeInsets.only(top: 5.0),
//                                  decoration: BoxDecoration(
//                                    shape: BoxShape.rectangle,
//                                    gradient: LinearGradient(colors: [
//                                      Colors.lightBlue,
//                                      Colors.blueAccent
//                                    ]),
//                                  ),
//                                  child: Row(
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    children: <Widget>[
//                                      Container(
//                                        //Renew button
//                                        child: FloatingActionButton(
//                                          child: Icon(Icons.autorenew),
//                                          mini: true,
//                                          backgroundColor: Colors.blueAccent,
//                                          onPressed: () {
//                                            setState(() {
//                                              items.clear();
//                                            });
//                                          },
//                                        ),
//                                      ),
//                                      Container(
//                                        //Play button
//                                        child: FloatingActionButton(
//                                          child: Icon(Icons.mic),
//                                          backgroundColor: Colors.green,
//                                          onPressed: () {
//                                            if (_isAvailable && !_isListening) {
//                                              _speechRecognition
//                                                  .listen(locale: _currentLocale)
//                                                  .then((result) =>
//                                                  print('$result'));
//                                            }
//                                          },
//                                        ),
//                                        margin: EdgeInsets.only(
//                                            top: 2.0,
//                                            bottom: 10.0,
//                                            left: 10.0,
//                                            right: 10.0),
//                                      ),
//                                      Container(
//                                        //Stop button
//                                        child: FloatingActionButton(
//                                          child: Icon(Icons.stop),
//                                          backgroundColor: Colors.orange,
//                                          mini: true,
//                                          onPressed: () {
//                                            if (_isListening) {
//                                              _speechRecognition.stop().then(
//                                                    (result) => setState(() =>
//                                                _isListening = result),
//                                              );
//                                            }
//                                          },
//                                        ),
//                                      ),
//                                    ],
//                                  )),
//                            ),
//                          ],
//                        ),
                      ],
                    ),
                  ),
                  new RecipesView(recipes),
                  new RecipesView(recipes)
                ]))));
  }

  void _onItemTapped(int index) {
    setState(() {
      _itemChangedHandler(index);
    });
  }

  void _itemChangedHandler(int index) {
    if (index == 0) {
      setState(() {
        items.clear();
      });
    } else if (index == 1) {
      setState(() {
        _showInputDialog();
      });
//      _speechRecognition.stop().then(
//            (result) =>
//            setState(() =>
//            _isListening = result),
//      );
    }
  }

  void onItemsChange() {
    setState(() => items);
  }

  void _showInputDialog() {
    showDialog(
        context: navigatorKey.currentState.overlay.context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  autofocus: true,
                  autocorrect: true,
                  decoration: InputDecoration(
                    labelText: "Add food item",
                    hintText: "E.g Chicken Breasts",
                    alignLabelWithHint: true,
                  ),
                  onChanged: (value) {
                    inputItem = value;
                  },
                ),
                IconButton(
                  icon: Icon(Icons.check_circle),
                  onPressed: () {
                    setState(() {
                      if (inputItem != "") {
                        items.add(inputItem);
                      }
                      inputItem = "";
                      _dismissDialog();
                    });
                  },
                )
              ],
            ),
            shape: CircleBorder(),
            contentPadding: EdgeInsets.all(60.0),
          );
        });
  }

  void _dismissDialog() {
    Navigator.pop(navigatorKey.currentState.overlay.context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
