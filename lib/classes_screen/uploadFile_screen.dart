import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tesma/constants/size_config.dart';
import 'package:tesma/constants/color.dart';
import 'package:tesma/models/classinf.dart';
import 'package:folder_picker/folder_picker.dart';

class UploadFileScreen extends StatefulWidget {
  final ClassInf classinf;
  final String userType;
  const UploadFileScreen({Key key, @required this.classinf, @required this.userType})
      : super(key: key);
  @override
  _UploadFileScreen createState() => _UploadFileScreen();
}

class _UploadFileScreen extends State<UploadFileScreen> {
  String path = "";
  Map<String, String> fileInfor = {'filename': '', 'size': '', 'dateUpload': ''};
  UploadTask task;
  File file;
  String classID;
  String userType;
  double percentage = 0;
  List fileURLsList = [];
  bool downloading = false;
  var progressString = "";
  @override
  void initState() {
    super.initState();
    classID = widget.classinf.classid;
    userType = widget.userType;
    WidgetsFlutterBinding.ensureInitialized();
    FlutterDownloader.initialize();
  }

  void _showToast(String context) {
    Fluttertoast.showToast(
      msg: context,
      backgroundColor: redColor,
      textColor: whiteColor,
      gravity: ToastGravity.CENTER,
    );
  }

  Future selectFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf', 'docx', 'jpg', 'png', 'mp4'],
    );
    if (result != null) {
      setState(() {
        file = File(result.files.single.path);
        print(file);
        path = result.files.first.name;
      });
      // await FirebaseStorage.instance.ref('$classID/$path').putFile(file);
      uploadFile();
    }
  }

  Future uploadFile() async {
    if (file == null) return;

    task = FirebaseStorage.instance.ref('$classID/$path').putFile(file);
    if (task == null) return;
    final snapshot = await task.whenComplete(() {
      _showToast("Uploaded");
    });
    final urlDownload = await snapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('classes')
        .doc(classID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data()['fileURLs'] != null) {
        setState(() {
          fileURLsList = documentSnapshot.data()['fileURLs'];
        });
      }
    });
    fileInfor['filename'] = path;
    fileInfor['size'] = snapshot.totalBytes < 1048576
        ? (snapshot.totalBytes ~/ 1024).toString() + ' KB'
        : (snapshot.totalBytes ~/ 1048576).toString() + ' MB';
    DateTime now = DateTime.now();
    fileInfor['dateUpload'] = now.toString().substring(0, 10);
    fileInfor['urlDownload'] = urlDownload;
    fileURLsList.add(fileInfor);
    FirebaseFirestore.instance
        .collection('classes')
        .doc(classID)
        .update({'fileURLs': fileURLsList});
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(
                color: royalBlueColor,
                fontFamily: 'SegoeUI',
                fontWeight: FontWeight.w300,
              ),
            );
          } else {
            return Container();
          }
        },
      );

  Widget uploadFileButton() {
    return DottedBorder(
      color: Colors.black,
      strokeWidth: 1,
      dashPattern: [10, 6],
      child: Container(
        alignment: Alignment.topCenter,
        height: 16 * SizeConfig.heightMultiplier,
        width: 86 * SizeConfig.widthMultiplier,
        child: Column(
          children: [
            Container(
              height: 5 * SizeConfig.heightMultiplier,
              width: 20 * SizeConfig.widthMultiplier,
              margin: EdgeInsets.only(
                top: 4 * SizeConfig.heightMultiplier,
                bottom: 2 * SizeConfig.heightMultiplier,
              ),
              child: InkWell(
                onTap: selectFile,
                child: Icon(
                  Icons.arrow_upward,
                  color: whiteColor,
                ),
              ),
              decoration: BoxDecoration(
                color: mediumPink,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Text(
              'Select your file to upload',
              style: TextStyle(
                color: royalBlueColor,
                fontFamily: 'SegoeUI',
                fontWeight: FontWeight.w300,
              ),
            ),
            task != null ? buildUploadStatus(task) : Container(),
          ],
        ),
      ),
    );
  }

  void _shareFile(String link, String filename) async {
    // Directory folderpath = Directory('/storage/emulated/0/Download/tesma/');
    // // await folderpath.create(recursive: true);
    // Dio dio = Dio();
    // await dio.download(link, folderpath.path + '/' + filename);
    // // folderpath = folderpath + '/' + filename;
    // // final savedDir = Directory(folderpath);
    // // await savedDir.create(recursive: true).then((value) async {
    // //   String _taskid = await FlutterDownloader.enqueue(
    // //     url: link,
    // //     fileName: filename,
    // //     savedDir: folderpath,
    // //     showNotification: true,
    // //     openFileFromNotification: false,
    // //   );
    // //   print(_taskid);
    // // });
    // _showToast("Download completed.\n$folderpath/$filename");

    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: link,
        chooserTitle: 'Example Chooser Title');
  }

  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                Container(
                  height: 50 * SizeConfig.heightMultiplier,
                  padding: EdgeInsets.only(
                    top: 3 * SizeConfig.heightMultiplier,
                    right: 7 * SizeConfig.widthMultiplier,
                    left: 7 * SizeConfig.widthMultiplier,
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream:
                          FirebaseFirestore.instance.collection('classes').doc(classID).snapshots(),
                      builder: (context, documentsnapshot) {
                        return !documentsnapshot.hasData
                            ? Container()
                            : documentsnapshot.data.data()['fileURLs'] == null
                                ? uploadFileButton()
                                : Container(
                                    child: ListView.builder(
                                        padding: const EdgeInsets.all(0),
                                        itemCount:
                                            documentsnapshot.data.data()['fileURLs'].length + 1,
                                        itemBuilder: (context, index) {
                                          return documentsnapshot.data.data()['fileURLs'].length >
                                                  index
                                              ? InkWell(
                                                  onTap: () async {
                                                    _shareFile(
                                                        documentsnapshot.data.data()['fileURLs']
                                                            [index]['urlDownload'],
                                                        documentsnapshot.data.data()['fileURLs']
                                                            [index]['filename']);
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 10 * SizeConfig.widthMultiplier,
                                                          child: Icon(
                                                            Icons.text_snippet,
                                                            size: 5 * SizeConfig.heightMultiplier,
                                                            color: Colors.redAccent,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 72 * SizeConfig.widthMultiplier,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              Container(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  documentsnapshot.data
                                                                          .data()['fileURLs'][index]
                                                                      ['filename'],
                                                                  style: TextStyle(
                                                                    color: Color(0xff181a54),
                                                                    fontFamily: 'SegoeUI',
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      documentsnapshot.data
                                                                              .data()['fileURLs']
                                                                          [index]['size'],
                                                                      style: TextStyle(
                                                                        color: Color(0xff181a54),
                                                                        fontSize: 8,
                                                                        fontFamily: 'SegoeUI',
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      documentsnapshot.data
                                                                              .data()['fileURLs']
                                                                          [index]['dateUpload'],
                                                                      style: TextStyle(
                                                                        color: Color(0xff181a54),
                                                                        fontSize: 12,
                                                                        fontFamily: 'SegoeUI',
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    margin: EdgeInsets.all(
                                                        0.5 * SizeConfig.heightMultiplier),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(5),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Color(0x3f000000),
                                                          offset: Offset(0.5, 2),
                                                          blurRadius: 4,
                                                          spreadRadius: 1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                    top: 5 * SizeConfig.heightMultiplier,
                                                    left: 0.5 * SizeConfig.heightMultiplier,
                                                    right: 0.5 * SizeConfig.heightMultiplier,
                                                    bottom: 0.5 * SizeConfig.heightMultiplier,
                                                  ),
                                                  child: uploadFileButton(),
                                                );
                                        }),
                                  );
                      }),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 3 * SizeConfig.heightMultiplier,
                  ),
                  height: 4.1 * SizeConfig.heightMultiplier,
                  width: 35 * SizeConfig.widthMultiplier,
                  child: InkWell(
                    child: Container(
                      height: 4.1 * SizeConfig.heightMultiplier,
                      width: 35 * SizeConfig.widthMultiplier,
                      alignment: Alignment.center,
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'SegoeUI',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  decoration: BoxDecoration(
                    color: redColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}
