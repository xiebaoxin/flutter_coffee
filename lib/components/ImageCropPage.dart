import 'dart:async';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCropperPage extends StatefulWidget {
  @override
  _ImageCropperPageState createState() => _ImageCropperPageState();
}

class _ImageCropperPageState extends State<ImageCropperPage> {
  File? _file;

  @override
  void dispose() {
    super.dispose();
    _file?.delete();
  }

  @override
  void initState() {
    super.initState();
    _openImage().catchError((e) {
      Navigator.of(context).pop(false);
    });
  }

  Widget _buildCroppingImage() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: _file != null
                ? Image.file(_file!, fit: BoxFit.contain)
                : Container(),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            alignment: AlignmentDirectional.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  child: Text(
                    '上传图片',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                  ),
                  onPressed: () => uploadImage(_file!),
                ),
                _buildOpenImage(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOpenImage() {
    return TextButton(
      child: Text(
        '选择图片',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
      ),
      onPressed: () => _openImage(),
    );
  }

  final picker = ImagePicker();

  Future<void> _openImage() async {
    final pfile = await picker.pickImage(source: ImageSource.gallery);
    if (pfile == null) return;

    setState(() {
      _file = File(pfile.path);
    });
  }

  Future uploadImage(File image) async {
    // Upload logic placeholder - original used image_crop and flutter_native_image
    // which are no longer available
  }

  Future createForm(File file) async {
    return FormData.fromMap({
      "offset": 0,
      "md5": md5.convert(await file.readAsBytes()),
      "photo": await MultipartFile.fromFile(file.path),
      "filesize": await file.length(),
      "wizard": 1
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
                Expanded(
                    child: Container(
                      child: _file == null ? Container() : _buildCroppingImage(),
                    )
                ),
              ],
            )
        )
    );
  }
}
