import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

class Word {
  String key;
  String meaning;
  String romajiWord;
  String kanaWord;
  String kanjiWord;
  String description;
  String spanishExample;
  String romajiExample;
  String kanaExample;
  String kanjiExample;
  String wordType;
  String attributes;

  Word({
      this.key,
      this.meaning,
      this.romajiWord,
      this.kanaWord,
      this.kanjiWord,
      this.description,
      this.spanishExample,
      this.romajiExample,
      this.kanaExample,
      this.kanjiExample,
      this.wordType,
      this.attributes
      });

  Word.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        meaning = snapshot.value["meaning"],
        romajiWord = snapshot.value["romajiWord"],
        kanaWord = snapshot.value["kanaWord"],
        kanjiWord = snapshot.value["kanjiWord"],
        description = snapshot.value["description"],
        spanishExample = snapshot.value["spanishExample"],
        romajiExample = snapshot.value["romajiExample"],
        kanaExample = snapshot.value["kanaExample"],
        kanjiExample = snapshot.value["kanjiExample"],
        wordType = snapshot.value["wordType"],
        attributes = snapshot.value["attributes"];

  toJason() {
    return {
      "meaning": meaning,
      "romajiWord": romajiWord,
      "kanaWord": kanaWord,
      "kanjiWord": kanjiWord,
      "description": description,
      "spanishExample": spanishExample,
      "romajiExample": romajiExample,
      "kanaExample": kanaExample,
      "kanjiExample": kanjiExample,
      "wordType": wordType,
      "attributes": attributes,
    };
  }

}
