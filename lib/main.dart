import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'movie.dart';
import 'search.dart';
import 'package:provider/provider.dart';
import 'add.dart';

Future<void> main() async {
  runApp(MyApp());
}

Future<String> getMoviesData(String path) async {
  return rootBundle.loadString(path);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: MovieList())],
      child: MaterialApp(
        home: HomeBody(),
        theme: ThemeData(
          backgroundColor: Colors.amber,
          cardColor: Colors.amber[100],
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}

class MovieList extends ChangeNotifier {
  List<MovieItem> movList = [];
  void addNew(MovieItem mov) {
    movList.add(mov);
    notifyListeners();
  }

  void removeItemAt(index) {
    movList.removeAt(index);
    notifyListeners();
  }

  List<MovieItem> get getMovList => movList;

  String get getLen => movList.length.toString();
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List<MovieItem> movieList = [];

  void _addMovieToList(MovieItem mov) {
    Provider.of<MovieList>(context, listen: false).addNew(mov);
  }

  @override
  Widget build(BuildContext context) {
    List<MovieItem> movieList =
        Provider.of<MovieList>(context, listen: true).getMovList;
    debugPrint('GET HERE');
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: Search(movieList));
              })
        ], title: Text("Laba3")),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellow,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddPage()));
          },
          child: Icon(
            Icons.add,
            color: Colors.black54,
          ),
        ),
        body: homePageBuilder(context));
  }

  Widget homePageBuilder(BuildContext context) {
    return FutureBuilder(
        future:
            DefaultAssetBundle.of(context).loadString("assets/MoviesList.txt"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var json = jsonDecode(snapshot.data.toString());
            for (var item in json["Search"]) {
              movieList.add(MovieItem.fromJson(item));
              _addMovieToList(MovieItem.fromJson(item));
            }
          }

          return Container(
            child: Consumer<MovieList>(
              builder: (context, movList, child) => new ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        Provider.of<MovieList>(context, listen: false)
                            .removeItemAt(index);
                      });
                    },
                    child: Card(
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(
                              top: 32, bottom: 32, left: 16, right: 16),
                          child: MovieItemListView(
                              mov:
                                  Provider.of<MovieList>(context, listen: false)
                                      .getMovList[index]),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieItemDetailedView(
                                      mov: movieList[index])));
                        },
                      ),
                    ),
                  );
                },
                itemCount: movieList == null ? 0 : movieList.length,
              ),
            ),
          );
        });
  }
}
