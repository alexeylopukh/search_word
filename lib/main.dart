import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:search_word/widget/words_widget.dart';

import 'interactor/game_field_generator_interactor.dart';
import 'widget/game_field_widget.dart';

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
  List<String> words = [
    'FLUTTER',
    'ANDROID',
    'DEVELOP',
    'GOOGLE',
    'KOTLIN',
    'SWIFT',
    'APPLE',
    'ALPHA',
    'ALEX',
    'VOVA',
    'IOS',
  ];
  int size = 7;

  GameFieldGeneratorInteractor generator;

  @override
  void initState() {
    generator = GameFieldGeneratorInteractor(words: words, size: size);
    generator.generateField();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
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
              generator: generator,
            ),
          ),
        ],
      ),
    ));
  }

  update() {
    if (mounted) setState(() {});
  }
}
