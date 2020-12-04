import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'views/search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return isIOS
        ? CupertinoApp(
            home: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('Index Flux'),
            ),
            child: MyHomePage(),
          ))
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Index Flux',
            theme: ThemeData(
                buttonTheme: ButtonThemeData(
                  buttonColor: Colors.deepPurple,
                  textTheme: ButtonTextTheme.primary,
                ),
                primarySwatch: Colors.deepPurple),
            home: MyHomePage(title: 'Index Flux'),
          );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    new Search(),
    new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/sketch.png',
          height: 100,
        ),
        Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text(
            'Under Construction',
            style: TextStyle(color: Colors.deepPurple),
          ),
        )
      ],
    )
  ];

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return isIOS
        ? CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.search),
                  title: Text('Search'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.clock),
                  title: Text('History'),
                ),
                
              ],
            ),
            tabBuilder: (context, index) {
              switch (index) {
                case 0:
                  return CupertinoTabView(builder: (context) {
                    return CupertinoPageScaffold(
                      child: Text('asdasdas',
                      style: TextStyle(color: Colors.deepPurple),),
                    );
                  });
                case 1:
                  return CupertinoTabView(builder: (context) {
                    return CupertinoPageScaffold(
                      child: Text('asdasdas'),
                    );
                  });
                
              }
            },
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  title: Text('Search'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  title: Text('History'),
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ));
  }
}
