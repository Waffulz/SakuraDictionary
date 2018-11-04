import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:sakura_jisho/models/word_model.dart';

class AnimatedSakuraList extends StatefulWidget {
  @override
  _AnimatedSakuraListState createState() => _AnimatedSakuraListState();
}

class _AnimatedSakuraListState extends State<AnimatedSakuraList> {
  DatabaseReference databaseReference;
  List<Word> words = List();
  Word word;
  final FirebaseDatabase database = FirebaseDatabase.instance;

  void _onEntryAdded(Event event) {
    setState(() {
      words.add(Word.fromSnapshot(event.snapshot));
    });
  }

  @override
  void initState() {
    super.initState();
    word = Word();
    databaseReference = database.reference().child("vocabulary");
    databaseReference.onChildAdded.listen(_onEntryAdded);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: FirebaseAnimatedList(
              query: databaseReference,
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return Card(
                  child: ListTile(
                    title: Text(words[index].meaning),
                    subtitle: Text(words[index].kanaWord),
                    trailing: Text(words[index].wordType),
                  ),
                );
              }
          ),
        ),
      ],
    );
  }


}
