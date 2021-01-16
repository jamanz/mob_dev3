import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;

class PhotosView extends StatefulWidget {
  List<StaggeredTile> _staggeredTiles = <StaggeredTile>[
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1)
  ];
  @override
  _PhotosViewState createState() => _PhotosViewState();
}

class _PhotosViewState extends State<PhotosView> {
  File _image;
  List<File> _imageList = [];

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
      _imageList.add(_image);
    });
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  List<StaggeredTile> _populStaggeredTiles() {
    debugPrint('Populate Sarted');
    List<StaggeredTile> _resList = [];
    for (int i = 0; i < 3; i++) {
      _resList.addAll(widget._staggeredTiles);
    }
    debugPrint('Populate OVER');
    return _resList;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('BEFORE POPULATE');
    List<StaggeredTile> _countedTiles = _populStaggeredTiles();
    debugPrint('AFTER POPULATE');
    return Container(
      child: Scaffold(
          // backgroundColor: Colors.purple[100],
          floatingActionButton: FloatingActionButton(
            heroTag: UniqueKey(),
            backgroundColor: Colors.cyan[300],
            child: Icon(
              Icons.add,
              color: Colors.black54,
            ),
            onPressed: () {
              _showPicker(context);
            },
          ),
          body: StaggeredGridView.countBuilder(
            primary: false,
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: NetImageProvider.fetchMages(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return new Center(
                      child: new FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: snapshot.data['hits'][index]['webformatURL']),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              );
            },
            staggeredTileBuilder: (int index) => _countedTiles[index],
            itemCount: _countedTiles.length,
          )),
    );
  }

  Widget _getPhotoWidget(BuildContext context, int index) {
    return Center(
        child: _imageList[index] != null
            ? Image.file(_imageList[index], fit: BoxFit.fitHeight)
            : FractionallySizedBox(
                widthFactor: 0.999,
                heightFactor: 0.999,
                child: Card(
                  color: Colors.cyan[200],
                ),
              ));
  }
}

class NetImageProvider {
  static String _apiKey = '19193969-87191e5db266905fe8936d565';
  static int count = 27;
  static String request = 'night+city';

  static Future<Map> fetchMages() async {
    var response = await http.get(
        "https://pixabay.com/api/?key=$_apiKey&q=$request&image_type=photo&per_page=$count");
    var jeson = await jsonDecode(response.body);
    return jeson;
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: NetImageProvider.fetchMages(),
        builder: (context, snapshot) {
          debugPrint(snapshot.data.toString());
          if (snapshot.hasData) {
            return new Center(
              child: new FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data['hits'][index]['previewURL']),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
