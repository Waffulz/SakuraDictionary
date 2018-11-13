import 'package:flutter/material.dart';
import 'package:sakura_jisho/models/word_model.dart';
import 'package:sakura_jisho/user_interface/sections/filter_section.dart';
import 'package:sakura_jisho/user_interface/vocabulary/dropdown_list.dart';
import 'package:sakura_jisho/utils/color_pallete.dart';
import 'package:sakura_jisho/utils/font_styles.dart';
import 'package:sakura_jisho/utils/routes.dart';
import 'package:firebase_database/firebase_database.dart';

class EditWord extends StatefulWidget {
  final Word editingWord;

  EditWord({
    this.editingWord,
  });

  @override
  _EditWordState createState() => _EditWordState();
}

class _EditWordState extends State<EditWord> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseDatabase sakuraDatabase = FirebaseDatabase.instance;
  DatabaseReference sakuraDatabaseReference;
  String selectedWordType = null;
  String selectedAdjetivoAttribute = null;
  String selectedVerbAttribute = null;
  String selectedAttribute = null;
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

  @override
  void initState() {
    super.initState();
    _loadWordTypeList();
    _loadAdjetiveAttributes();
    _loadVerbAttributes();
    _loadCounterAttributes();
    _changeBetweenList(widget.editingWord.wordType);
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

  Word word;

  _editWord(String key, String editField, String editText) {
    sakuraDatabaseReference = sakuraDatabase
        .reference()
        .child("vocabulary")
        .child(key)
        .child(editField);

    sakuraDatabaseReference.set(editText);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        darkColor,
        darkLightColor,
      ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _appBarBuilder(),
        body: _bodyBuilder(),
      ),
    );
  }

  Widget _appBarBuilder() {
    return AppBar(
      title: Text('Editar Vocabulario'),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  Widget _bodyBuilder() {
    final String key = widget.editingWord.key;
    var editedValue = "";
    return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Form(
                    key: formKey,
                    child: Table(
                      columnWidths: {
                        0: IntrinsicColumnWidth(),
                        2: IntrinsicColumnWidth()
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      //defaultColumnWidth: IntrinsicColumnWidth(),
                      children: [
                        TableRow(children: [
                          _staticText('Palabra:'),
                          TextFormField(
                              style: CustomTextStyle.dynamicEditSinglelineText(
                                  context),
                              initialValue: widget.editingWord.meaning,
                              onSaved: (val) =>
                                  widget.editingWord.meaning = val,
                              validator: (val) => val == "" ? val : null,
                              decoration:
                                  InputDecoration.collapsed(hintText: null)),
                          IconButton(
                              onPressed: () {
                                editedValue = "";
                                final FormState form = formKey.currentState;
                                form.save();
                                _handleSubmit(
                                    key, 'meaning', widget.editingWord.meaning);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 15.0,
                              )),
                        ]),
                        TableRow(children: [
                          _staticText('Romaji:'),
                          TextFormField(
                              style: CustomTextStyle.dynamicEditSinglelineText(
                                  context),
                              initialValue: widget.editingWord.romajiWord,
                              onSaved: (val) =>
                                  widget.editingWord.romajiWord = val,
                              validator: (val) => val == "" ? val : null,
                              decoration:
                                  InputDecoration.collapsed(hintText: null)),
                          IconButton(
                              onPressed: () {
                                editedValue = "";
                                final FormState form = formKey.currentState;
                                form.save();
                                _handleSubmit(key, 'romajiWord',
                                    widget.editingWord.romajiWord);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 15.0,
                              )),
                        ]),
                        TableRow(children: [
                          _staticText('Kana:'),
                          TextFormField(
                              style: CustomTextStyle.dynamicEditSinglelineText(
                                  context),
                              initialValue: widget.editingWord.kanaWord,
                              onSaved: (val) =>
                                  widget.editingWord.kanaWord = val,
                              validator: (val) => val == "" ? val : null,
                              decoration:
                                  InputDecoration.collapsed(hintText: null)),
                          IconButton(
                              onPressed: () {
                                editedValue = "";
                                final FormState form = formKey.currentState;
                                form.save();
                                _handleSubmit(key, 'kanaWord',
                                    widget.editingWord.kanaWord);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 15.0,
                              )),
                        ]),
                        TableRow(children: [
                          _staticText('Kanji:'),
                          TextFormField(
                              style: CustomTextStyle.dynamicEditSinglelineText(
                                  context),
                              initialValue: widget.editingWord.kanjiWord,
                              onSaved: (val) =>
                                  widget.editingWord.kanjiWord = val,
                              validator: (val) => val == "" ? val : null,
                              decoration:
                                  InputDecoration.collapsed(hintText: null)),
                          IconButton(
                              onPressed: () {
                                editedValue = "";
                                final FormState form = formKey.currentState;
                                form.save();
                                _handleSubmit(key, 'kanjiWord',
                                    widget.editingWord.kanjiWord);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 15.0,
                              )),
                        ]),
                        TableRow(children: [
                          _staticText('Tipo de palabra:'),
                          DropdownButtonHideUnderline(
                            child: Theme(
                              data: ThemeData(
                                canvasColor: darkLightColor,
                              ),
                              child: DropdownButton(
                                value: widget.editingWord.wordType,
                                items: wordTypeList,
                                onChanged: (selectedValue) {
                                  widget.editingWord.wordType = selectedValue;
                                  selectedAttribute = null;
                                  _changeBetweenList(selectedValue);
                                  _handleSubmit(key, 'wordType', selectedValue);
                                  _editWord(key, 'attributes', "");
                                  setState(() {});
                                },
                                style:
                                    CustomTextStyle.dynamicEditSinglelineText(
                                        context),
                                hint: Text('Tipo palabra'),
                              ),
                            ),
                          ),
                          Container()
                        ]),
                        TableRow(children: [
                          _staticText('Característica:'),
                          DropdownButtonHideUnderline(
                            child: Theme(
                              data: ThemeData(canvasColor: darkLightColor),
                              child: DropdownButton(
                                value: selectedAttribute,
                                items: attributesDynamicList,
                                onChanged: (selectedValue) {
                                  selectedAttribute = selectedValue;
                                  widget.editingWord.attributes = selectedValue;
                                  _handleSubmit(
                                      key, 'attributes', selectedValue);
                                  setState(() {});
                                },
                                style:
                                    CustomTextStyle.dynamicEditSinglelineText(
                                        context),
                                hint: Text(
                                  'Característica',
                                  style: TextStyle(color: Colors.white24),
                                ),
                              ),
                            ),
                          ),
                          Container()
                        ]),
                        TableRow(children: [
                          _staticText('Descripción:'),
                          TextFormField(
                              style: CustomTextStyle.dynamicEditSinglelineText(
                                  context),
                              initialValue: widget.editingWord.description,
                              onSaved: (val) =>
                                  widget.editingWord.description = val,
                              validator: (val) => val == "" ? val : null,
                              decoration:
                                  InputDecoration.collapsed(hintText: null)),
                          IconButton(
                              onPressed: () {
                                editedValue = "";
                                final FormState form = formKey.currentState;
                                form.save();
                                _handleSubmit(key, 'description',
                                    widget.editingWord.description);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 15.0,
                              )),
                        ]),
                        TableRow(children: [
                          _staticText('Ejemplo español:'),
                          TextFormField(
                              style: CustomTextStyle.dynamicEditSinglelineText(
                                  context),
                              initialValue: widget.editingWord.spanishExample,
                              onSaved: (val) =>
                                  widget.editingWord.spanishExample = val,
                              validator: (val) => val == "" ? val : null,
                              decoration:
                                  InputDecoration.collapsed(hintText: null)),
                          IconButton(
                              onPressed: () {
                                editedValue = "";
                                final FormState form = formKey.currentState;
                                form.save();
                                _handleSubmit(key, 'spanishExample',
                                    widget.editingWord.spanishExample);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 15.0,
                              )),
                        ]),
                        TableRow(children: [
                          _staticText('Ejemplo Romaji:'),
                          TextFormField(
                              style: CustomTextStyle.dynamicEditSinglelineText(
                                  context),
                              initialValue: widget.editingWord.romajiExample,
                              onSaved: (val) =>
                                  widget.editingWord.romajiExample = val,
                              validator: (val) => val == "" ? val : null,
                              decoration:
                                  InputDecoration.collapsed(hintText: null)),
                          IconButton(
                              onPressed: () {
                                editedValue = "";
                                final FormState form = formKey.currentState;
                                form.save();
                                _handleSubmit(key, 'romajiExample',
                                    widget.editingWord.romajiExample);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 15.0,
                              )),
                        ]),
                        TableRow(children: [
                          _staticText('Ejemplo Kana:'),
                          TextFormField(
                              style: CustomTextStyle.dynamicEditSinglelineText(
                                  context),
                              initialValue: widget.editingWord.kanaExample,
                              onSaved: (val) =>
                                  widget.editingWord.kanaExample = val,
                              validator: (val) => val == "" ? val : null,
                              decoration:
                                  InputDecoration.collapsed(hintText: null)),
                          IconButton(
                              onPressed: () {
                                editedValue = "";
                                final FormState form = formKey.currentState;
                                form.save();
                                _handleSubmit(key, 'kanaExample',
                                    widget.editingWord.kanaExample);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 15.0,
                              )),
                        ]),
                        TableRow(children: [
                          _staticText('Ejemplo Kanji:'),
                          TextFormField(
                              style: CustomTextStyle.dynamicEditSinglelineText(
                                  context),
                              initialValue: widget.editingWord.kanjiExample,
                              onSaved: (val) =>
                                  widget.editingWord.kanjiExample = val,
                              validator: (val) => val == "" ? val : null,
                              decoration:
                                  InputDecoration.collapsed(hintText: null)),
                          IconButton(
                              onPressed: () {
                                editedValue = "";
                                final FormState form = formKey.currentState;
                                form.save();
                                _handleSubmit(key, 'kanjiExample',
                                    widget.editingWord.kanjiExample);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 15.0,
                              )),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _staticText(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        text,
        style: CustomTextStyle.staticTopPanelText(context),
      ),
    );
  }

  Widget _dynamicText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        text,
        style: CustomTextStyle.dynamicTopPanelText(context),
      ),
    );
  }

  void _handleSubmit(String key, String editingField, String editedText) {
    if (editingField != null) {
      _editWord(key, editingField, editedText);
    } else {
      _editWord(key, editingField, "");
    }

    if (editedText == widget.editingWord.meaning ||
        editedText == widget.editingWord.romajiWord ||
        editedText == widget.editingWord.kanaWord ||
        editedText == widget.editingWord.kanjiWord) {
      searchIndex = widget.editingWord.meaning +
          widget.editingWord.romajiWord +
          widget.editingWord.kanaWord +
          widget.editingWord.kanjiWord;
      _handleSubmit(key, 'searchIndex', searchIndex);
    }
  }
}

class EditVocabulary extends StatefulWidget {
  @override
  _EditVocabularyState createState() => _EditVocabularyState();
}

class _EditVocabularyState extends State<EditVocabulary> {
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

  @override
  void initState() {
    super.initState();
    _loadWordTypeList();
    _loadAdjetiveAttributes();
    _loadVerbAttributes();
    _loadCounterAttributes();

    word = new Word();
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
        break;
    }
  }

  void _handleSubmit() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();
    }

    word.searchIndex =
        (word.meaning + word.romajiWord + word.kanaWord + word.kanjiWord)
            .toString();
    //save form data to firebase databa se
    databaseReference.push().set(word.toJason());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarBuilder(),
      body: _bodyBuilder(),
    );
  }

  Widget _appBarBuilder() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: _navigateToFilterSections,
      ),
      title: Text('Editar Vocabulario'),
    );
  }

  Widget _bodyBuilder() {
    return ListView(children: <Widget>[
      Column(
        children: <Widget>[
          Form(
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
                            // validator: (val) => val == "" ? val : null,
                            decoration: InputDecoration(labelText: 'Romaji*'),
                          ),
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            onSaved: (val) => word.kanaWord = val,
                            //validator: (val) => val == "" ? val : null,
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
                ListTile(
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
                    //validator: (val) => val == "" ? val : null,
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
                    //validator: (val) => val == "" ? val : null,
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
                    //validator: (val) => val == "" ? val : null,
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
                    //validator: (val) => val == "" ? val : null,
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
        ],
      ),
    ]);
  }

  void _onEntryAdded(Event event) {
    setState(() {});
  }
}
