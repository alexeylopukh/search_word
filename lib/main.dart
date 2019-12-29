import 'package:flutter/material.dart';
import 'package:search_word/game_field_widget.dart';
import 'package:search_word/words_widget.dart';

import 'game_field_generator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serach word',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> words = [];
  int size = 7;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final generator = GameFieldGenerator(words: words, size: size);
    generator.generateField();

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                onPressed: () => update(),
                icon: Icon(Icons.refresh),
              )
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 37, vertical: 22),
              child: WordsWidget(
                words: generator.addedWords,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(18),
              child: GameFieldWidget(
                field: generator.gameField.field,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                onChanged: (text) {
                  words = text.toUpperCase().split(' ');
                  if (words.last == '') {
                    words.removeLast();
                  }
                  update();
                },
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText:
                        "Enter space separated words (example: vova alex)",
                    fillColor: Colors.white70),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                onChanged: (text) {
                  try {
                    size = int.parse(text);
                    update();
                  } catch (e) {}
                },
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Size",
                    fillColor: Colors.white70),
              ),
            )
          ],
        ));
  }

  update() {
    setState(() {});
  }
}
