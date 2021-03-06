import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'movie.dart';
import 'search.dart';
import 'package:provider/provider.dart';
import 'add.dart';
import 'album.dart';
import 'chart.dart';
import 'package:http/http.dart' as http;
import 'dbmovmodel.dart';

void main() {
  runApp(MyApp());
}

class Requester {
  static const String _apiKey = '7e9fe69e';
  String request;
  String url;

  Future<http.Response> fetchSearch(String request) {
    return http
        .get("http://www.omdbapi.com/?apikey=$_apiKey&s=$request&page=1");
  }

  Future<http.Response> fetchFullInfo(String imdbid) {
    return http.get("http://www.omdbapi.com/?apikey=$_apiKey&i=$imdbid");
  }
}

Future<String> getMoviesData(String path) async {
  return rootBundle.loadString(path);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MovieList()),
        ChangeNotifierProvider(create: (context) => dbMov())
      ],
      child: MaterialApp(
        home: DefaultTabController(length: 1, child: HomeBody()),
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

  int get getLen => movList.length;
}

class dbMov extends ChangeNotifier {
  MovieDatabase db = MovieDatabase();
  dbMov() {
    db.initDB();
  }

  void addNewToDB(MovieItem mov) {
    db.addMovie(mov);
    notifyListeners();
  }

  Future<List<MovieItem>> retrieveFromDB() async {
    return db.retrieveMovies();
  }

  void removeFromDB(String id) {
    db.deleteMovie(id);
    notifyListeners();
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List<MovieItem> movieList = [];
  int indexTab = 0;
  Requester requester = new Requester();

  void _addMovieToList(MovieItem mov) {
    Provider.of<MovieList>(context, listen: false).addNew(mov);
  }

  @override
  Widget build(BuildContext context) {
    List<MovieItem> movies = [];
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: Search());
                  })
            ],
            bottom: TabBar(
              onTap: (index) {
                setState(() {
                  indexTab = index;
                });
              },
              tabs: [
                Tab(icon: Icon(Icons.movie)),
                // Tab(icon: Icon(Icons.photo)),
                // Tab(icon: Icon(Icons.add_chart)),
                // Tab(icon: Icon(Icons.insert_chart))
              ],
            ),
            title: Text("Laba8")),
        floatingActionButton: indexTab == 0
            ? FloatingActionButton(
                backgroundColor: Colors.yellow,
                heroTag: UniqueKey(),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddPage()));
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black54,
                ),
              )
            : null,
        body: TabBarView(
          children: [
            homePageBuilder(context),
            // PhotosView(),
            // ChartView(),
            // ChartView()
          ],
        ));
  }

  Widget homePageBuilder(BuildContext context) {
    return ListView.builder(
      itemCount: Provider.of<MovieList>(context, listen: true).getLen,
      itemBuilder: (contex, index) {
        return Card(
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(
                  top: 32, bottom: 32, left: 16, right: 16),
              child: MovieItemListView(
                  mov: Provider.of<MovieList>(context, listen: true)
                      .getMovList[index]),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MovieItemDetailedView(
                    mov: Provider.of<MovieList>(context, listen: true)
                        .getMovList[index]);
              }));
            },
          ),
        );
      },
    );
  }
}
