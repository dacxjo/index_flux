import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchResult extends StatefulWidget {
  final int pagePosition;
  final int pageIndex;
  final List titles;
  final String url;

  SearchResult(
      {Key key,
      @required this.pagePosition,
      @required this.pageIndex,
      @required this.titles,
      @required this.url})
      : super(key: key);

  @override
  _SearchResultState createState() =>
      _SearchResultState(pagePosition, pageIndex, titles, url);
}

class _SearchResultState extends State<SearchResult> {
  int pagePosition;
  int pageIndex;
  List titles;
  String url;
  _SearchResultState(this.pagePosition, this.pageIndex, this.titles, this.url);

  _launchURL() async {
    var url2 = 'https://engine.arpentechs.com/$url';
    if (await canLaunch(url2)) {
      await launch(url2);
    } else {
      throw 'Could not launch $url2';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('Search Result'),
        ),
        body: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(children: <Widget>[
                  Text(pageIndex.toString(),
                      style:
                          TextStyle(color: Colors.deepPurple, fontSize: 100)),
                  Text('Page Index')
                ]),
                Column(children: <Widget>[
                  Text(pagePosition.toString(),
                      style:
                          TextStyle(color: Colors.deepPurple, fontSize: 100)),
                  Text(
                    'Page Position',
                  ),
                ])
              ],
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                  onPressed: _launchURL,
                  child: Text('Show result screenshot'),
                )),
            Divider(),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Result List',
                  style: TextStyle(color: Colors.deepPurple),
                )),
            Expanded(
                child: new ListView.builder(
                    itemCount: titles.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new Card(
                          child: ListTile(title: Text(titles[index])));
                    }))
          ],
        ));
  }
}
