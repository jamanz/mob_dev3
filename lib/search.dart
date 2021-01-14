import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lab3/main.dart';
import 'dart:async' show Future;
import 'movie.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';

class Search extends SearchDelegate {
  List<MovieItem> movList = [];
  Map<String, int> hash = {};
  String selectedResult = "";
  List<String> recentList = [];

  Search(this.movList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      )
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

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestList = [];
    List<String> availableList = [];
    for (MovieItem mov in movList) {
      hash.addAll({mov.info['Title']: movList.indexOf(mov)});
      availableList.add(mov.info['Title']);
    }
    query.isEmpty
        ? suggestList = recentList
        : suggestList
            .addAll(availableList.where((element) => element.contains(query)));
    return ListView.builder(
      itemCount: suggestList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestList[index],
          ),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: () {
            selectedResult = suggestList[index];
            showResults(context);
            recentList.add(selectedResult);
            close(context, CircularProgressIndicator());
            return Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MovieItemDetailedView(
                        mov: movList.elementAt(hash[selectedResult]))));
          },
        );
      },
    );
  }
}
