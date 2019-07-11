import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:rerecipe_app/Views/Misc/IngredientsView.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;
  String _currentLocale = "";
  String resultText = "";

  Set<String> items = new Set();

  @override
  void initState() {
    items.add("Cheese");
    items.add("Beef");
    items.add("Noodles");
    items.add("Rice");
    items.add("Pork");
    items.add("Chicken");
    super.initState();
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
              if(item.length>0){
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.lightBlueAccent[100],
            appBar: AppBar(
                title: Text(
                  'My Fridge',
                  textScaleFactor: 1.2,
                ),
                backgroundColor: Colors.blueAccent),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(top:5.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            gradient: LinearGradient(
                                colors: [Colors.lightBlue, Colors.blueAccent]),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                //Renew button
                                child: FloatingActionButton(
                                  child: Icon(Icons.autorenew),
                                  mini: true,
                                  backgroundColor: Colors.blueAccent,
                                  onPressed: () {
                                    setState(() {
                                      items.clear();
                                    });
                                  },
                                ),
                              ),
                              Container(
                                //Play button
                                child: FloatingActionButton(
                                  child: Icon(Icons.mic),
                                  backgroundColor: Colors.green,
                                  onPressed: () {
                                    if (_isAvailable && !_isListening) {
                                      _speechRecognition
                                          .listen(locale: _currentLocale)
                                          .then((result) => print('$result'));
                                    }
                                  },
                                ),
                                margin: EdgeInsets.only(
                                    top: 2.0,
                                    bottom: 10.0,
                                    left: 10.0,
                                    right: 10.0),
                              ),
                              Container(
                                //Stop button
                                child: FloatingActionButton(
                                  child: Icon(Icons.stop),
                                  backgroundColor: Colors.orange,
                                  mini: true,
                                  onPressed: () {
                                    if (_isListening) {
                                      _speechRecognition.stop().then(
                                            (result) => setState(
                                                () => _isListening = result),
                                          );
                                    }
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ],
            )));
  }

  void onItemsChange() {
    setState(() => items);
  }
}
