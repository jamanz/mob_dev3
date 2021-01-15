import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotosView extends StatefulWidget {
  @override
  _PhotosViewState createState() => _PhotosViewState();
}

class _PhotosViewState extends State<PhotosView> {
  File _image;
  List<File> _imageList = [];

  List<Color> _kColors = const <Color>[
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.pink,
    Colors.indigo,
    Colors.purple,
    Colors.blueGrey,
    Colors.lightGreen,
    Colors.pink,
    Colors.blue
  ];

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

  List<StaggeredTile> _showedStaggeredTiles = [
    const StaggeredTile.count(1, 1),
  ];
  int c = 0;

  @override
  Widget build(BuildContext context) {
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
              _showedStaggeredTiles.add(_showedStaggeredTiles[c]);
              c++;
            },
          ),
          body: StaggeredGridView.countBuilder(
            primary: false,
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            itemBuilder: _getPhotoWidget,
            staggeredTileBuilder: (int index) {
              debugPrint('StaggeredBUILDER INDEX: $index');
              return _staggeredTiles.sublist(index, index + 1)[0];
            },
            itemCount: _showedStaggeredTiles.length - 1,
          )),
    );
  }

  List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
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
