import 'package:meta/meta.dart';

class Word {
  final int externalId;
  final String meaning;
  final String romajiWord;
  final String kanaWord;
  final String kanjiWord;
  final String description;
  final String spanishExample;
  final String romajiExample;
  final String kanaExample;
  final String kanjiExample;
  final String wordType;
  final String attributes;

  Word ({
    this.externalId,
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
}