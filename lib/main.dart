import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;

Future<void> main() async {
  runApp(MyApp());
}

Future<String> getMoviesData(String path) async {
  return rootBundle.loadString(path);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("Movies Lab3"),
        backgroundColor: Colors.green[800],
      ),
      backgroundColor: Colors.amber[50],
      body: HomeBody(),
    ));
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  // HomeBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            DefaultAssetBundle.of(context).loadString("assets/MoviesList.txt"),
        builder: (context, snapshot) {
          var jdata = jsonDecode(snapshot.data.toString());
          print(jdata["Search"]);
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 32, bottom: 32, left: 16, right: 16),
                  child: MovieItem(
                      title: jdata['Search'][index]["Title"],
                      year: jdata['Search'][index]["Year"],
                      type: jdata['Search'][index]["Type"],
                      poster: jdata['Search'][index]["Poster"]),
                ),
              );
            },
            itemCount: jdata == null ? 0 : jdata['Search'].length,
          );
        });
  }
}

class MovieItem extends StatelessWidget {
  String title;
  String year;
  String imdbID;
  String type;
  String poster;

  MovieItem({this.title, this.year, this.imdbID, this.type, this.poster});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Container(
                margin: const EdgeInsets.only(right: 10),
                width: 100,
                height: 150,
                child: poster.isEmpty
                    ? Container(
                        padding: EdgeInsets.all(30),
                        child: CircularProgressIndicator(
                          strokeWidth: 6.0,
                          backgroundColor: Colors.green[800],
                        )) //  Icon(Icons.no_cell, color: Colors.red, size: 30.0)
                    : Image(image: AssetImage("assets/Posters/" + poster)))),
        Expanded(
            flex: 3,
            child: MovieDescription(title: title, year: year, type: type))
      ],
    );
  }
}

class MovieDescription extends StatelessWidget {
  String year;
  String title;
  String type;

  MovieDescription({this.title, this.year, this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          Text(year, style: const TextStyle(fontSize: 10.0)),
          Text(type, style: const TextStyle(fontSize: 10.0)),
        ],
      ),
    );
  }
}
