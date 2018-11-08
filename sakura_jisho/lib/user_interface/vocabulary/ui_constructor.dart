import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sakura_jisho/models/word_model.dart';


class EditVocabulary extends StatefulWidget {
  String hintDescription = 'Inserta una Descripción (Opcional)';
  String hintExample = 'Inserta un ejemplo en español (Opcional)';
  String hintRomajiExample =
      'Inserta la traducció utilizando Romaji (Opcional)';
  String hintKanaExample = 'Inserta la traducción utilizando Kanas (Opcional)';
  String hintKanjiExample =
      'Inserta la traducción utilizando Kanjis (Opcional)';

  @override
  _EditVocabularyState createState() => _EditVocabularyState();
}

class _EditVocabularyState extends State<EditVocabulary> {
  var wordMeaning;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarBuilder(),
      body: _bodyBuilder(),
    );
  }

  Widget _appBarBuilder() {
    return AppBar(
      title: Text('Editar Vocabulario'),
    );
  }

  Widget _bodyBuilder() {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            Form(
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    ListTile(
                        title: _underLineTextFieldBuilder(wordMeaning, 'Palabra')),
                    ListTile(title: _rowBuilder()),
                    SizedBox(height: 10.0),
                    _dropDownBuilder(),
                    SizedBox(height: 10.0),
                    ListTile(
                        title: _outLineTextFieldBuilder(
                            wordMeaning, 'Descripción', widget.hintDescription)),
                    ListTile(
                        title: _outLineTextFieldBuilder(
                            wordMeaning, 'Ejemplo', widget.hintExample)),
                    ListTile(
                        title: _outLineTextFieldBuilder(wordMeaning,
                            'Ejemplo Romaji', widget.hintRomajiExample)),
                    ListTile(
                        title: _outLineTextFieldBuilder(
                            wordMeaning, 'Ejemplo Kana', widget.hintKanaExample)),
                    ListTile(
                        title: _outLineTextFieldBuilder(
                            wordMeaning, 'Ejemplo Kanji', widget.hintKanjiExample)),
                    _editFlatButtonBuilder()
                  ],
                ))
          ],
        ),
      ],
    );
  }

//ListTile(title: DropDownField()),
  Widget _underLineTextFieldBuilder(var dynamicValue, String label) {
    return UnderLineField(dynamicValue: dynamicValue, textFieldLabel: label);
  }

  Widget _outLineTextFieldBuilder(var dynamicValue, String label, String hint) {
    return OutLineField(
      dynamicValue: dynamicValue,
      textFieldLabel: label,
      hintText: hint,
    );
  }

  Widget _rowBuilder() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              child: _underLineTextFieldBuilder(wordMeaning, 'Romaji')),
        ),
        SizedBox(width: 5.0),
        Expanded(
          child:
          Container(child: _underLineTextFieldBuilder(wordMeaning, 'Kana')),
        ),
        SizedBox(width: 5.0),
        Expanded(
          child: Container(
              child: _underLineTextFieldBuilder(wordMeaning, 'Kanji')),
        )
      ],
    );
  }

  Widget _dropDownBuilder() {
    return DropDownField();
  }

  Widget _editFlatButtonBuilder() {
    return Container(
      color: Colors.black12,
      width: double.infinity,
      child: FlatButton(onPressed: () => print(wordMeaning), child: Text('Editar')),
    );
  }
}

class UnderLineField extends StatefulWidget {
  var dynamicValue;
  String textFieldLabel;

  UnderLineField({this.dynamicValue, this.textFieldLabel});

  @override
  _UnderLineFieldState createState() => _UnderLineFieldState();
}

class _UnderLineFieldState extends State<UnderLineField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (val) => widget.dynamicValue = val,
      validator: (val) => val == "" ? val : null,
      decoration: InputDecoration(labelText: widget.textFieldLabel),
    );
  }
}

class OutLineField extends StatefulWidget {
  var dynamicValue;
  String textFieldLabel;
  String hintText;

  OutLineField({this.dynamicValue, this.textFieldLabel, this.hintText});

  @override
  _OutLineFieldState createState() => _OutLineFieldState();
}

class _OutLineFieldState extends State<OutLineField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (val) => widget.dynamicValue = val,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: widget.textFieldLabel,
        hintText: widget.hintText,
        border: OutlineInputBorder(),
      ),
    );
  }
}

class DropDownField extends StatefulWidget {
  @override
  _DropDownFieldState createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  List<DropdownMenuItem<String>> attributesDynamicList = [];

  _changeBetweenList(String value) {
    switch (value) {
      case "Adjetivo":
        attributesDynamicList = adjetiveAtributesList;
        break;
      case "Verbo":
        attributesDynamicList = verbAttibutesList;
        break;
      case "Contador":
        attributesDynamicList = counterAtributesList;
        break;
      default:
        break;
    }
  }
  @override
  void initState() {
    _loadWordTypeList();
    _loadAdjetiveAttributes();
    _loadVerbAttributes();
    _loadCounterAttributes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.black12,
          child: ListTile(
            title: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: selectedWordType,
                items: wordTypeList,
                onChanged: (selectedValue) {
                  selectedWordType = selectedValue;
                  selectedCounterAttribute = null;
                  _changeBetweenList(selectedValue);
                  setState(() {});
                },
                hint: Text('Tipo de palabra'),
              ),
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          color: Colors.black12,
          child: ListTile(
            title: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: selectedCounterAttribute,
                items: attributesDynamicList,
                onChanged: (selectedValue) {
                  selectedCounterAttribute = selectedValue;
                  setState(() {});
                },
                hint: Text('Caracteristica'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String selectedWordType = null;
  String selectedAdjetivoAttribute = null;
  String selectedVerbAttribute = null;
  String selectedCounterAttribute = null;

  List<DropdownMenuItem<String>> wordTypeList = [];
  List<String> wordType = [
    'Sustantivo',
    'Verbo',
    'Adjetivo',
    'Contador',
    'Adverbio'
  ];

  _loadWordTypeList() {
    //clean the list before refill it again
    wordTypeList = [];

    wordTypeList = wordType
        .map((val) => DropdownMenuItem<String>(
      child: Text(val),
      value: val,
    ))
        .toList();
  }

  List<DropdownMenuItem<String>> adjetiveAtributesList = [];
  List<String> adjetiveAtributes = ['Tipo い', 'Tipo な'];

  _loadAdjetiveAttributes() {
    adjetiveAtributesList = [];
    adjetiveAtributesList = adjetiveAtributes
        .map((val) => DropdownMenuItem<String>(
      child: Text(val),
      value: val,
    ))
        .toList();
  }

  List<DropdownMenuItem<String>> verbAttibutesList = [];
  List<String> verbAttibutes = ['Grupo 1', 'Grupo 2', 'Grupo 3'];

  _loadVerbAttributes() {
    verbAttibutesList = [];
    verbAttibutesList = verbAttibutes
        .map((val) => DropdownMenuItem<String>(
      child: Text(val),
      value: val,
    ))
        .toList();
  }

  List<DropdownMenuItem<String>> counterAtributesList = [];
  List<String> counterAttibutes = [
    'General',
    'Personas',
    'Cosas planas',
    'Libros y cuadernos',
    'Cosas cilindricas',
    'Animales pequeños',
    'Intentos',
    'Días',
    'Años',
    'Horas',
    'Meses',
    'Semanas',
    'Orden númerico',
    'Máquinas y autos',
    'Pisos',
    'Bebicas en vaso',
    'Cosas pequeñas',
    'Animales grandes',
  ];

  _loadCounterAttributes() {
    counterAtributesList = [];
    counterAtributesList = counterAttibutes
        .map((val) => DropdownMenuItem<String>(
      child: Text(val),
      value: val,
    ))
        .toList();
  }
}
