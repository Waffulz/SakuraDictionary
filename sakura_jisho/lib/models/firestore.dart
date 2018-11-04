import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Word {
  String key;
  String title;
  String subtitle;

  Word(this.title, this.subtitle);

  Word.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        title = snapshot.value["title"],
        subtitle = snapshot.value["subtitle"];

  toJson() {
    return {"title": title, "subtitle": subtitle};
  }
}

class CrudTries extends StatefulWidget {
  @override
  _CrudTriesState createState() => _CrudTriesState();
}

class _CrudTriesState extends State<CrudTries> {
  List<Word> words = List();
  Word word;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    word = new Word("", "");
    databaseReference = database.reference().child("crud_tries");
    databaseReference.onChildAdded.listen(_onEntryAdded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CrudTries'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Form(
              key: formKey,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  ListTile(
                    title: TextFormField(
                      onSaved: (val) => word.title = val,
                      validator: (val) => val == "" ? val : null,
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      onSaved: (val) => word.subtitle = val,
                      validator: (val) => val == "" ? val : null,
                    ),
                  ),

                  ListTile(
                    title: Container(
                      color: Colors.black12,
                      width: double.infinity,
                      child: FlatButton(
                        onPressed: () {
                          handleSubmit();
                        },
                        child: Text('Submit'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onEntryAdded(Event event) {
    setState(() {
      words.add(Word.fromSnapshot(event.snapshot));
    });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();
      //save form data to database
      databaseReference.push().set(word.toJson());
    }
  }
}
