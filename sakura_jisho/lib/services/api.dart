//Lib that allow us to convert JSON files in dart
import 'dart:convert';
import 'package:sakura_jisho/models/word_model.dart';

//Class that handle the functions to convert json data in UI data
class WordApi {

  //This function convert json data into a list
  static List<Word> allWordsFromJson(String jsonData) {
    //the list take the model object of words in the vocabulary names Word
    List<Word> words = [];

    //Decode the json data and add the entries into the list
    json
        .decode(jsonData)['vocabulary']
        .forEach((word) => words.add(_forMapWord(word)));
    return words;
  }

  //map take a string title defined in the json file, and a dynamic value wich
  //is the value of the entry in the json
  static Word _forMapWord(Map<String, dynamic> map) {
    return Word(
      //assign the model objects to a json data field
      meaning: map['meaning'],
      romajiWord: map['romaji_word'],
      kanaWord: map['kana_word'],
      kanjiWord: map['kanji_word'],
      description: map['description'],
      spanishExample: map['spanish_example'],
      romajiExample: map['romaji_example'],
      kanaExample: map['kana_only_example'],
      kanjiExample: map['kanji_with_example'],
      wordType: map['word_type'],
      attributes: map['attributes'],
    );


  }
}
