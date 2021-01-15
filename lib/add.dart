import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lab3/main.dart';
import 'dart:async' show Future;
import 'movie.dart';
import 'package:form_validator/form_validator.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  MovieItem mov = MovieItem.simple();
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  void _validate() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      Provider.of<MovieList>(context, listen: false).addNew(mov);
      debugPrint(
          Provider.of<MovieList>(context, listen: false).getLen.toString());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adding new Movie'),
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                validator: ValidationBuilder().maxLength(50).build(),
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (var value) {
                  mov.title = value.toString();
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                validator: ValidationBuilder()
                    .minLength(3)
                    .regExp(RegExp('^([Mm]ovie|[Ss]erial)\$'),
                        "Only: Movie or Serial")
                    .build(),
                decoration: InputDecoration(
                  labelText: 'Type',
                  helperText: 'Supported types: Movie, Serial',
                ),
                onSaved: (var value) {
                  mov.type = value.toString();
                },
              ),
              TextFormField(
                validator: ValidationBuilder()
                    .regExp(RegExp('(19[7-9][0-9]|20[0-2][0-9])'),
                        'Only in range 1970-2029')
                    .build(),
                decoration: InputDecoration(
                  labelText: 'Year',
                  helperText: 'Year in range 1970-2029',
                ),
                onSaved: (var value) {
                  mov.type = value.toString();
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _validate,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
