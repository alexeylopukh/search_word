import 'package:flutter/cupertino.dart';
import 'package:search_word/model/word_model.dart';

class WordsWidget extends StatefulWidget {
  final List<WordModel> words;

  WordsWidget({@required this.words});

  @override
  State<StatefulWidget> createState() {
    return WordsWidgetState();
  }
}

class WordsWidgetState extends State<WordsWidget> {
  List<WordModel> get words => widget.words;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    words.forEach((word) {
      widgets.add(Text(
        " ${word.word} ",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
      ));
    });
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.25)),
          borderRadius: BorderRadius.all(Radius.circular(13))),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: widgets,
      ),
    );
  }
}
