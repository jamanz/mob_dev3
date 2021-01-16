import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:lab3/main.dart';
import 'dart:async' show Future;
import 'movie.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';

class Search extends SearchDelegate {
  List<MovieItem> movList = [];
  List<MovieItem> suggestList = [];
  MovieItem selectedResult;
  // List<String> recentList = [];

  Search();

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = '';
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => futBuilder(context)));
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  String _apiKey = '7e9fe69e';
  Future<Map<String, dynamic>> fetchSearch(String request) async {
    var response = await http
        .get("http://www.omdbapi.com/?apikey=$_apiKey&s=$request&page=1");
    return await jsonDecode(response.body);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // List<String> availableList = [];
    return futBuilder(context);
  }

  Widget futBuilder(BuildContext context) {
    return FutureBuilder(
      future: fetchSearch(query),
      builder: (context, snapshot) {
        suggestList = [];
        if (query.length == 0) {
          return ListTile(title: Text(""));
        }
        if (snapshot.hasData) {
          if (snapshot.data['Response'] == "False") {
            return ListTile(title: Text(""));
          } else {
            for (var item in snapshot.data['Search']) {
              suggestList.add(MovieItem.fromJson(item));
            }
          }
          return ListView.builder(
              itemCount: suggestList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child:
                      Card(child: MovieItemListView(mov: suggestList[index])),
                  onTap: () {
                    selectedResult = suggestList[index];
                    showResults(context);
                    // recentList.add(selectedResult);
                    Provider.of<dbMov>(context, listen: false)
                        .addNewToDB(selectedResult);
                    Provider.of<MovieList>(context, listen: false)
                        .addNew(selectedResult);
                    close(context, CircularProgressIndicator());
                    return Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MovieItemDetailedView(mov: selectedResult)));
                  },
                );
              });
        }
      },
    );
  }
}
