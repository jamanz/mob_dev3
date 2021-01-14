import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;

class MovieItem {
  String title;
  String year;
  String rated;
  String released;
  String runtime;
  String genre;
  String director;
  String writer;
  String actors;
  String plot;
  String language;
  String country;
  String awards;
  String poster;
  String imdbRating;
  String imdbVotes;
  String imdbID;
  String type;
  String production;

  Map<String, dynamic> jsonFull;

  MovieItem.simple();

  MovieItem({this.title, this.year, this.imdbID, this.type, this.poster}) {
    if (this.imdbID != 'noid') {
      loadExtendedInfo('assets/imdb/' + this.imdbID + '.txt');
    }
  }

  factory MovieItem.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return MovieItem(
      title: json['Title'] as String,
      year: json["Year"] as String,
      type: json["Type"] as String,
      poster: json["Poster"] as String,
      imdbID: json['imdbID'] as String,
    );
  }

  Map<String, dynamic> get info {
    return {
      "Title": this.title ?? 'None',
      "Year": this.year ?? 'None',
      "Rated": this.rated ?? 'None',
      "Released": this.released ?? 'None',
      "Runtime": this.runtime ?? 'None',
      "Genre": this.genre ?? 'None',
      "Director": this.director ?? 'None',
      "Writer": this.writer ?? 'None',
      "Actors": this.actors ?? 'None',
      "Plot": this.plot ?? 'None',
      "Language": this.language ?? 'None',
      "Country": this.country ?? 'None',
      "Awards": this.awards ?? 'None',
      "Poster": this.poster ?? 'None',
      "imdbRating": this.imdbRating ?? 'None',
      "imdbVotes": this.imdbVotes ?? 'None',
      "imdbID": this.imdbID ?? 'None',
      "Type": this.type ?? 'None',
      "Production": this.production ?? 'None'
    };
  }

  void loadExtendedInfo(path) async {
    jsonFull = await jsonDecode(await rootBundle.loadString(path))
        as Map<String, dynamic>;
    this.rated = await jsonFull['Rated'];
    this.released = await jsonFull['Released'];
    this.runtime = await jsonFull['Runtime'];
    this.genre = await jsonFull['Genre'];
    this.director = await jsonFull['Director'];
    this.writer = await jsonFull['Writer'];
    this.actors = await jsonFull['Actors'];
    this.plot = await jsonFull['Plot'];
    this.language = await jsonFull['Language'];
    this.country = await jsonFull['Country'];
    this.awards = await jsonFull['Awards'];
    this.imdbRating = await jsonFull['imdbRating'];
    this.imdbVotes = await jsonFull['imdbVotes'];
    this.production = await jsonFull['Production'];
  }

  contains(String query) {}
}

class MovieItemListView extends StatelessWidget {
  MovieItem mov;
  MovieItemListView({this.mov});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 2,
          child: Container(
              margin: const EdgeInsets.only(right: 10),
              width: 100,
              height: 150,
              child: mov.info['Poster'].isEmpty | (mov.info['Poster'] == 'None')
                  ? Center(
                      //
                      child: CircularProgressIndicator(
                      strokeWidth: 6.0,
                      backgroundColor: Colors.green[800],
                    )) //  Icon(Icons.no_cell, color: Colors.red, size: 30.0)
                  : Image(
                      image:
                          AssetImage("assets/Posters/" + mov.info['Poster'])))),
      Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  mov.info['Title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                  ),
                ),
                Text(mov.info['Year'], style: const TextStyle(fontSize: 10.0)),
                Text(mov.info['Type'], style: const TextStyle(fontSize: 10.0)),
              ],
            ),
          )),
    ]);
  }
}

class MovieItemDetailedView extends StatelessWidget {
  MovieItem mov;

  MovieItemDetailedView({MovieItem this.mov});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movie Detail Page')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              height: 250,
              width: 100,
              child: mov.info['Poster'].isEmpty | (mov.info['Poster'] == 'None')
                  ? Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 6.0, backgroundColor: Colors.green[800]))
                  : Image.asset("assets/Posters/" + mov.info['Poster']),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
              child: Column(
                children: [
                  Text('Title: ${mov.info["Title"]}'),
                  Text('Year: ${mov.info["Year"]}'),
                  Text('Type: ${mov.info["Type"]}'),
                  Text('Genre: ${mov.info["Genre"]}'),
                  Text('Director: ${mov.info["Director"]}'),
                  Text('Actors: ${mov.info["Actors"]}'),
                  Text('Country: ${mov.info["Country"]}'),
                  Text('Language: ${mov.info["Language"]}'),
                  Text('Production: ${mov.info["Production"]}'),
                  Text('Released: ${mov.info["Released"]}'),
                  Text('Runtime: ${mov.info["Runtime"]}'),
                  Text('Awards: ${mov.info["Awards"]}'),
                  Text('Rating: ${mov.info["Rating"]}'),
                  Text('Plot: ${mov.info["Plot"]}')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
