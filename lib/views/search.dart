import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:index_flux/views/search_result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:index_flux/models/search_result_model.dart';
import 'package:query_params/query_params.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchEngineController = TextEditingController();
  final TextEditingController _searchTermController = TextEditingController();
  final TextEditingController _titleToSearchController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _showCustom = false;
  bool _doingSearch = false;

  String _picked = "Diseño Web Barcelona | Arpen Technologies";

  void chooseTitle(String selected) {
    switch (selected) {
      case 'Custom':
        setState(() {
          _showCustom = true;
          _picked = "Custom";
          _titleToSearchController.value = new TextEditingValue(text: '');
        });
        break;
      case 'Arpen Technologies | Diseño Web Barcelona':
        setState(() {
          _showCustom = false;
          _picked = "Arpen Technologies | Diseño Web Barcelona";
          _titleToSearchController.value = new TextEditingValue(
              text: 'Arpen Technologies | Diseño Web Barcelona');
        });
        break;
      case 'Diseño Web Barcelona - Arpen Technologies':
        setState(() {
          _showCustom = false;
          _picked = "Diseño Web Barcelona - Arpen Technologies";
          _titleToSearchController.value = new TextEditingValue(
              text: 'Diseño Web Barcelona - Arpen Technologies');
        });
        break;
    }
  }

  Future<dynamic> doSearch() async {
    if (_formKey.currentState.validate()) {
      Scaffold.of(context).showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 2000),
          content: Text('Arpen elves are doing the search...')));
      setState(() {
        _doingSearch = true;
      });

      // set up POST request arguments
      String url = 'https://engine.arpentechs.com/api/v1/search';
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      };

      Map<String, String> body = {
        "titleToSearch": _titleToSearchController.text,
        "pageAddress": _searchEngineController.text,
        "searchTerm" : _searchTermController.text
      };

      print(body);
      http.Response response =
          await http.post(url, headers: headers, body: body);

    
      if (response.statusCode == 200) {
        setState(() {
          _doingSearch = false;
        });

        print(response.body);
        var data = json.decode(response.body);
        var geted = new SearchResultModel(data);

        setState(() {
          _doingSearch = false;
        });
        Navigator.of(context).push(new MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new SearchResult(
                  pagePosition: geted.pagePos,
                  pageIndex: geted.pageIndex,
                  titles: geted.titles,
                  url: geted.screenShot);
            },
            fullscreenDialog: true));
      } else {
        print(json.decode(response.body));
        print(response.headers);
        print(response.request);
        setState(() {
          _doingSearch = false;
        });
        Scaffold.of(context).showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 4000),
            backgroundColor: Colors.red[700],
            content: Text('Error ${response.statusCode} : Sorry, try again')));
      }
    }
  }

  @override
  void initState() {
    _searchEngineController.value =
        new TextEditingValue(text: 'https://www.google.es');
    _titleToSearchController.value =
        new TextEditingValue(text: 'Diseño Web Barcelona | Arpen Technologies');
  }

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return _doingSearch == true
        ? const CircularProgressIndicator()
        : Container(
            child: Form(
            key: _formKey,
            child: ListView(children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 20),
                child: TextFormField(
                    enabled: false,
                    controller: _searchEngineController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search Engine',
                        hintText: 'Choose Search Engine')),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                    controller: _searchTermController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the search term';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search Term',
                        hintText: 'ex. Diseño web barcelona')),
              ),
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Title to Search: '),
                    RadioButtonGroup(
                        padding: EdgeInsets.only(left: 0),
                        margin: EdgeInsets.only(left: 0),
                        labelStyle: new TextStyle(
                            fontSize: 12, color: Colors.deepPurple),
                        labels: <String>[
                          "Diseño Web Barcelona - Arpen Technologies",
                          "Arpen Technologies | Diseño Web Barcelona",
                          'Custom'
                        ],
                        picked: _picked,
                        onSelected: (String selected) =>
                            this.chooseTitle(selected)),
                    Visibility(
                      visible: this._showCustom ? true : false,
                      child: TextFormField(
                          controller: _titleToSearchController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Title to search',
                              hintText:
                                  'ex. Arpen Technologies | Agencia Digital')),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: RaisedButton(
                  onPressed: () => this.doSearch(),
                  child: Text('Begin search'),
                ),
              ),
            ]),
          ));
  }
}
