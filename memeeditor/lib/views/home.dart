import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey globalKey = new GlobalKey();

  String headerText = "";
  String footerText = "";

  File? _image;
  File? _imageFile;

  bool imageSelected = false;
  bool hasImage = false;
  File? image;
  Random rng = new Random();
  Future<Null> _pickImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    _image = pickedImage != null ? File(pickedImage.path) : null;
    if (_image != null) {
      setState(() {
        imageSelected = true;
      });
      Directory('storage/emulated/0/' + 'MemeGenerator')
          .create(recursive: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        
        title: Text(
          'Memer',
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 45),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.red.withOpacity(0.9),
            statusBarIconBrightness: Brightness.light),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 14,
              ),
              RepaintBoundary(
                key: globalKey,
                child: Padding(
                  padding: const EdgeInsets.only(left :25.0),
                  child: Stack(
                    children: <Widget>[
                      _image != null
                          ? Image.file(
                              _image!,
                              height: 300,
                              fit: BoxFit.fitHeight,
                            )
                          : Container(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                headerText.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 26,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 3.0,
                                      color: Colors.black87,
                                    ),
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 8.0,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  footerText.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 26,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 3.0,
                                        color: Colors.black87,
                                      ),
                                      Shadow(
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 8.0,
                                        color: Colors.black87,
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              imageSelected
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            onChanged: (val) {
                              setState(() {
                                headerText = val;
                              });
                            },
                            decoration:
                                InputDecoration(hintText: "Banner Text"),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextField(
                            onChanged: (val) {
                              setState(() {
                                footerText = val;
                              });
                            },
                            decoration:
                                InputDecoration(hintText: "Footer Text"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            color: Colors.teal,
                            onPressed: () {
                              takeScreenshot();
                            },
                            child: Text("Save"),
                          ),
                          SizedBox(
                            height: 20.0,
                          )
                        ],
                      ),
                    )
                  : Container(
                      child: Center(
                        child: Text("Select image to generate meme"),
                      ),
                    ),
              _imageFile != null ? Image.file(_imageFile!) : Container(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pickImage();
        },
        child: Icon(Icons.add_a_photo),
        backgroundColor: Colors.red,
      ),
    );
  }

  takeScreenshot() async {
    final RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    final ByteData? byteData = await (image.toByteData(
        format: ui.ImageByteFormat.png) as Future<ByteData?>);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    print(pngBytes);

    File imgFile = new File('$directory/memer${rng.nextInt(200)}.png');
    setState(() {
      _imageFile = imgFile;
    });
    _savefile(_imageFile!);

    imgFile.writeAsBytes(pngBytes);
  }

  _savefile(File file) async {
    await _askPermission();
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(await file.readAsBytes()));
  }

  _askPermission() async {
    Map<Permission, PermissionStatus> permissions =
        await [Permission.storage, Permission.photos].request();
    final info = permissions[Permission.storage].toString();
    print(info);
  }
}
