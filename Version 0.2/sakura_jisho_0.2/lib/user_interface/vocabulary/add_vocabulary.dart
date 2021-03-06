import 'package:flutter/material.dart';
import 'package:sakura_jisho/models/word_model.dart';
import 'package:sakura_jisho/user_interface/sections/filter_section.dart';
import 'package:sakura_jisho/utils/color_pallete.dart';
import 'package:sakura_jisho/utils/routes.dart';
import 'package:firebase_database/firebase_database.dart';


class AddVocabulary extends StatefulWidget {
  @override
  _AddVocabularyState createState() => _AddVocabularyState();
}

class _AddVocabularyState extends State<AddVocabulary> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FirebaseDatabase sakuraDatabase = FirebaseDatabase.instance;

  List<Word> wordsList = List();

  Word word;
  DatabaseReference databaseReference;

  String selectedWordType = null;
  String selectedAdjetivoAttribute = null;
  String selectedVerbAttribute = null;
  String selectedCounterAttribute = null;
  String searchIndex = "";

  List<DropdownMenuItem<String>> attributesDynamicList = [];

  List<DropdownMenuItem<String>> wordTypeList = [];
  List<String> wordType = [
    'Sustantivo',
    'Verbo',
    'Adjetivo',
    'Contador',
    'Adverbio'
  ];

  _loadWordTypeList() {
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
    'Bebidas en vaso',
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

  @override
  void initState() {
    super.initState();
    _loadWordTypeList();
    _loadAdjetiveAttributes();
    _loadVerbAttributes();
    _loadCounterAttributes();

    word = new Word();
    databaseReference = sakuraDatabase.reference().child("vocabulary");
    databaseReference.onChildAdded.listen(_onEntryAdded);
  }

  _navigateToFilterSections() {
    Navigator.of(context).pop(FadePageRoute(
        builder: (c) {
          return FilterSection();
        },
        settings: RouteSettings()));
  }

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
        attributesDynamicList = [];
        break;
    }
  }

  void _handleSubmit() {
    final FormState form = formKey.currentState;
    if(word.wordType != null) {
      if (form.validate()) {
        form.save();
        _showSnackBar();
        //form.reset();
        word.searchIndex =
            (word.meaning + word.romajiWord + word.kanaWord + word.kanjiWord)
                .toString();
        //save form data to firebase database
        databaseReference.push().set(word.toJason());
      }
    }

  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  _showSnackBar() {
    final snackBar = SnackBar(
      content:
      Text('Palabra agregada'),
      duration: Duration(seconds: 3),
      backgroundColor: Color(0XFF27253D),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            darkColor,
            darkLightColor
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: scaffoldKey,
        appBar: _appBarBuilder(),
        body: _bodyBuilder(),
      ),
    );
  }

  Widget _appBarBuilder() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: _navigateToFilterSections,
      ),
      title: Text('Añadir Vocabulario'),
    );
  }

  Widget _bodyBuilder() {
    return ListView(children: <Widget>[
      Column(
        children: <Widget>[
          Theme(
            data: ThemeData.dark(


            ),
            child: Form(
              key: formKey,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  ListTile(
                    title: TextFormField(
                      onSaved: (val) => word.meaning = val,
                      validator: (val) => val == "" ? val : null,
                      decoration: InputDecoration(
                        labelText: 'Palabra*',
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              onSaved: (val) => word.romajiWord = val,
                              validator: (val) => val == "" ? val : null,
                              decoration: InputDecoration(labelText: 'Romaji*'),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              onSaved: (val) => word.kanaWord = val,
                              validator: (val) => val == "" ? val : null,
                              decoration: InputDecoration(labelText: 'Kana*'),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              onSaved: (val) => word.kanjiWord = val,
                              decoration: InputDecoration(labelText: 'Kanji*'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.black26,
                    child: ListTile(
                      title: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: selectedWordType,
                          items: wordTypeList,
                          onChanged: (selectedValue) {
                            selectedWordType = selectedValue;
                            selectedCounterAttribute = null;
                            _changeBetweenList(selectedValue);
                            word.wordType = selectedValue;
                            setState(() {});
                          },
                          hint: Text('Tipo palabra*'),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: selectedCounterAttribute,
                        items: attributesDynamicList,
                        onChanged: (selectedValue) {
                          selectedCounterAttribute = selectedValue;
                          word.attributes = selectedValue;
                          setState(() {});
                        },
                        hint: Text('Característica'),
                      ),
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      onSaved: (val) => word.description = val,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        hintText: 'Inserta una descripción',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      onSaved: (val) => word.spanishExample = val,
                      validator: (val) => val == "" ? val : null,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Ejemplo*',
                        hintText: 'Traducción en español',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      onSaved: (val) => word.romajiExample = val,
                      validator: (val) => val == "" ? val : null,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Ejemplo*',
                        hintText: 'Traduce el ejemplo usando Romaji',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      onSaved: (val) => word.kanaExample = val,
                      validator: (val) => val == "" ? val : null,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Ejemplo Kana*',
                        hintText: 'Utiliza hiragana y katakana',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      onSaved: (val) => word.kanjiExample = val,
                      validator: (val) => val == "" ? val : null,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Ejemplo Kanji*',
                        hintText: 'Incorpora kanjis en el ejemplo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ListTile(
                      title: Padding(
                    padding: const EdgeInsets.only(right: 80.0),
                    child: Text(
                      '* Campos requeridos',
                      style: TextStyle(fontSize: 12.0, color: Colors.red),
                    ),
                  )),
                  Container(
                    width: double.infinity,
                    height: 50.0,
                    color: Colors.black12,
                    child: FlatButton(
                      onPressed: () {
                        _handleSubmit();
                      },
                      child: Text('Agregar'),
                    ),
                  ),
                  SizedBox(height: 25.0),
                ],
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  void _onEntryAdded(Event event) {
    setState(() {});
  }
}
