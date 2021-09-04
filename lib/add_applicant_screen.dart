import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutterhivesample/DownloadTask.dart';
import 'package:flutterhivesample/applicant.dart';
import 'package:flutterhivesample/employee_list_screen.dart';
import 'package:hive/hive.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'DownloadTask.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddOrEditEmployeeScreen extends StatefulWidget {
  AddOrEditEmployeeScreen();

  @override
  State<StatefulWidget> createState() {
    return AddEditEmployeeState();
  }
}

class AddEditEmployeeState extends State<AddOrEditEmployeeScreen> {
  String _localPath;
  TextEditingController controllerfirstName = new TextEditingController();
  TextEditingController controllerlastName = new TextEditingController();
  TextEditingController controllermobile = new TextEditingController();
  TextEditingController controllergender = new TextEditingController();
  TextEditingController controlleraddress = new TextEditingController();
  TextEditingController controllerimage = new TextEditingController();
  TextEditingController controllerresume = new TextEditingController();
  String image_url = "";
  String resume_url = "";
  Directory dir;
  String text = "Uplaod resume";
  String image_text = "Upload Image";
  bool enable_button = false;
  var getFirstName;
  var getLastName;
  var getMobile;
  var getGender;
  var getaddress;

  @override
  void initState() {
    _async_tasks();
    super.initState();
  }

  _async_tasks() async {
    dir = await getApplicationDocumentsDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              texteditinglabelRow("Applicant Name:", controllerfirstName, false,
                  controllermobile.text),
              texteditinglabelRow("Applicant Last Name:", controllerlastName,
                  false, controllermobile.text),
              texteditinglabelRow(
                  "Mobile No.", controllermobile, false, controllermobile.text),
              texteditinglabelRow("Applicant Gender:", controllergender, false,
                  controllermobile.text),
              texteditinglabelRow("Applicant Address:", controlleraddress,
                  false, controllermobile.text),
              texteditinglabelRow("Applicant image:", controllerimage, true,
                  controllermobile.text),
              ResumeLabelRow("Applicant Resume:", controllerresume, true,
                  controllermobile.text, context),
              SizedBox(height: 100),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: enable_button
                        ? MaterialStateProperty.all(Colors.blue)
                        : MaterialStateProperty.all(Colors.grey)),
                child: Text("Submit",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                onPressed: () async {
                  getFirstName = controllerfirstName.text;
                  getLastName = controllerlastName.text;
                  getMobile = controllermobile.text;
                  getGender = controllergender.text;
                  getaddress = controlleraddress.text;

                  if (check_if_fields_are_empty()) {
                    if (image_url.isNotEmpty && resume_url.isNotEmpty) {
                      Applicant addApplicant = new Applicant(
                        firstname: getFirstName,
                        lastname: getLastName,
                        mobile: getMobile,
                        Gender: getGender,
                        address: getaddress,
                        image_url: image_url,
                        resume_url: resume_url,
                      );
                      var box = await Hive.openBox<Applicant>('Applicant');
                      box.add(addApplicant);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please wait while the files are uploading");
                    }
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EmployeesListScreen()),
                        (r) => false);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Fill all the fields before clicking submit");
                  }
                },
              )
            ],
          ),
        ),
      )),
    );
  }

  Row ResumeLabelRow(String label, TextEditingController controller,
      bool is_file, String getMobile, BuildContext context) {
    var picker_file;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            width: 70, child: Text(label, style: TextStyle(fontSize: 14))),
        SizedBox(width: 20),
        Expanded(
          child: is_file
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(text),
                    IconButton(
                        icon: Icon(Icons.camera),
                        onPressed: () async {
                          FilePickerResult result =
                              await FilePicker.platform.pickFiles();
                          if (result != null) {
                            setState(() {
                              text = "Uploading resume";
                            });
                            File file = File(result.files.single.path);
                            uploadPic(File(file.path), getMobile, false);
                          } else {
                            // User canceled the picker
                            Fluttertoast.showToast(
                                msg:
                                    "Please take a resume to create the profile");
                          }
                        }),
                  ],
                )
              : TextField(controller: controller),
        )
      ],
    );
  }

  Row texteditinglabelRow(String label, TextEditingController controller,
      bool is_file, String getMobile) {
    ImagePicker picker = ImagePicker();
    var picker_file;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            width: 70, child: Text(label, style: TextStyle(fontSize: 14))),
        SizedBox(width: 20),
        Expanded(
          child: is_file
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(image_text),
                    IconButton(
                        icon: Icon(Icons.camera),
                        onPressed: () async {
                          final file = await picker.pickImage(
                              source: ImageSource.camera);
                          if (file != null) {
                            setState(() {
                              image_text = "Uploading image";
                            });
                            uploadPic(File(file.path), getMobile, true);
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Please take a image to create the profile");
                          }
                        }),
                    IconButton(
                        icon: Icon(Icons.photo_album),
                        onPressed: () async {
                          final file = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (file != null) {
                            setState(() {
                              image_text = "Uploading image";
                            });
                            uploadPic(File(file.path), getMobile, true);
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Please select a image to create the profile");
                          }
                        }),
                  ],
                )
              : TextField(controller: controller),
        )
      ],
    );
  }

  Future<String> uploadPic(File _image1, String number, bool is_image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String url;
    Reference ref = storage.ref().child(_image1.path);
    UploadTask uploadTask = ref.putFile(_image1);
    uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();

      setState(() {
        if (is_image) {
          image_url = url;
          image_text = "Uploaded image";
          if (resume_url.isNotEmpty) {
            enable_button = true;
          }
        } else {
          resume_url = url;
          text = "Uploaded resume";
          if (image_url.isNotEmpty) {
            enable_button = true;
          }
        }
      });
    }).catchError((onError) {
      print(onError);
    });
    return url;
  }

  bool check_if_fields_are_empty() {
    if (getFirstName.isNotEmpty &&
        getLastName.isNotEmpty &&
        getMobile.isNotEmpty &&
        getGender.isNotEmpty &&
        getaddress.isNotEmpty &&
        image_url.isNotEmpty &&
        resume_url.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
