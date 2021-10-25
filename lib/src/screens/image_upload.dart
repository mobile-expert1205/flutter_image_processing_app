import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/widgets/cutstom_text_button.dart';

class ImageScreen extends StatefulWidget {
  /// The page name to navigate to.
  static const String pageName = 'ImageScreen';

  /// Returns State object for this widget.
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

/// State class for SearchScreen widget.
class _ImageScreenState extends State<ImageScreen> {

  static const MethodChannel _channel = const MethodChannel('tips.word.wordfinderx/image');


  var height;
  var width;
  XFile? _imageFile;
  // TransformedImage? _transfomed;
  String? _filePath;
  String? _imagePath;
  String black_letters =' ';
  String white_letters =' ';
  String letters_to_play=' ';

  var _testPoint;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      // key: _scaffoldKey,
      backgroundColor: AppColors.backgroundColor,
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      decoration: BoxDecoration(color: AppColors.secondaryColor),
      child: Column(
        children: [
          _imageFile == null
              ? SizedBox(
                  height: height * 0.6,
                  child: Image.asset(
                    'assets/images/imgPic.png',
                    fit: BoxFit.fill,
                  ))
              : SizedBox(
                  height: height * 0.6,
                  child: Image.file(
                    (File(_imageFile!.path)),
                    fit: BoxFit.cover,
                  ),
                ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextButton(
                buttonWidth: 80,
                text: 'Select',
                onTap: () {
                  showPicker(context);
                },
              ),
              SizedBox(width: 10.0),
              _imageFile != null
                  ? CustomTextButton(
                      buttonWidth: 140,
                      text: 'recognition',
                      onTap: () {
                        detectImg();
                      },
                    )
                  : Text(''),
              SizedBox(
                width: 5,
              ),
              CustomTextButton(
                buttonWidth: 140,
                text: 'Select & Scan',
                onTap: getImage,
              ),
            ],
          ),
          // SizedBox(
          //   height: 5.0,
          // ),
          // Text(
          //   "Calculated values: x: ${_testPoint != null ? _testPoint!.x : "-"}, y: ${_testPoint != null ? _testPoint!.y : "-"}",
          // ),
          // SizedBox(
          //   height: 5.0,
          // ),
          // Text(
          //   'Cropped image path: $_imagePath\n',
          //   style: TextStyle(fontSize: 12),
          //   maxLines: 2,
          // ),

          SizedBox(
            height: 5.0,
          ),
          Text(
            'Black letters: $black_letters\n',
            style: TextStyle(fontSize: 12),
            maxLines: 2,
          ),

          SizedBox(
            height: 5.0,
          ),
          Text(
            'white letters: $white_letters\n',
            style: TextStyle(fontSize: 12),
            maxLines: 2,
          ),

          SizedBox(
            height: 5.0,
          ),
          Text(
            'letters to play: $letters_to_play\n',
            style: TextStyle(fontSize: 12),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  void detectImg() async {
    try {


      // var c = await ImageFeatureDetector.detectRectangles(_filePath);
      if (_imageFile != null) {
        final Map params = <String, dynamic> {
          'filePath': _imageFile?.path??null,
        };

        print('making native call with $params');

        String resp = await _channel.invokeMethod('find_board',params);

        print('received  response');

        var respArr = resp.split(";;");

        black_letters = respArr[0];
        white_letters = respArr[1];
        letters_to_play = respArr[2];
       // _imageFile = XFile(resp.toString());

        setState(() {

        });

        // var transformed =
        //     await ImageFeatureDetector.detectRectangles(_filePath);
        //
        // for (int w = 0; w < transformed.contour.length; w++) {
        //   print('output print x ${transformed.contour[w].x}');
        //   print('output print y  ${transformed.contour[w].y}');
        // }
        // setState(() {
        //   // _transfomed = transformed;
        // });
        // // setState(() {
        // //   _contour = c;
        // // });}
        // setState(() {
        //   _testPoint = RelativeCoordianteHelper.calculatePointDinstances(
        //     Point(x: 0.05, y: 0.05),
        //     ImageDimensions(500, 500),
        //   );
        // });
        // print('output print 2 ${_testPoint.x}');
        //



      }
    } on PlatformException {
      print("error happened");
    }
  }

  Future<void> getImage() async {
    String? imagePath;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      // imagePath = (await EdgeDetection.detectEdge);
      // print("$imagePath");
    } on PlatformException {
      imagePath = 'Failed to get cropped image path.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _imagePath = imagePath;
    });
  }

  void showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Library'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (pickedFile != null) {
        _imageFile = pickedFile;
        _filePath = pickedFile.path;
      }
    });
  }

  imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      // maxWidth: 500,
      // maxHeight: 500,
    );

    setState(() {
      if (pickedFile != null) {
        _imageFile = pickedFile;
        _filePath = pickedFile.path;
      }
    });
  }
}
