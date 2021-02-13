import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/resource/resource_bloc.dart';
import 'package:resourcify/models/models.dart';

import 'constants.dart';

class AddResourceScreen extends StatefulWidget {
  final String type;
  final List<Category> categories;

  const AddResourceScreen(
      {Key key, @required this.type, @required this.categories})
      : super(key: key);
  @override
  _AddResourceScreenState createState() => _AddResourceScreenState();
}

class _AddResourceScreenState extends State<AddResourceScreen> {
  Category year;
  Category department;
  Category subject;
  List<Category> categories;
  List<Category> departmentList = [];
  List<Category> yearList = [];

  List<Category> subjectList = [];
  File file;
  TextEditingController fileNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    categories = widget.categories;
    yearList = categories.where((cat) => cat.type == 'year').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${widget.type}'),
        centerTitle: true,
      ),
      body: BlocConsumer<ResourceBloc, ResourceState>(
        listener: (context, state) {
          print(state);
          if (state is ResourceError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ResourcesLoaded) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Center(
                child: ListView(
                  children: [
                    Container(
                      height: 300,
                      margin:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey[400], width: 1),
                        color: Colors.white,
                      ),
                      child: file != null
                          ? widget.type == 'image'
                              ? Image.file(
                                  file,
                                  fit: BoxFit.cover,
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.description,
                                      size: 130,
                                    ),
                                    Text('Added file ${file.uri}')
                                  ],
                                )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6.0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.add),
                                    iconSize: 50,
                                    color: Colors.blue,
                                    onPressed: _pickFile,
                                  ),
                                ),
                                Text('Upload ${widget.type}'),
                              ],
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Text(
                        'FILE NAME',
                        style: TextStyle(
                            color: Colors.black54,
                            // fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1),
                      ),
                      child: TextField(
                        textCapitalization: TextCapitalization.words,
                        controller: fileNameController,
                        decoration: InputDecoration(
                          filled: true,
                          border: InputBorder.none,
                          fillColor: Colors.grey[100],
                          contentPadding: EdgeInsets.only(top: 14, left: 10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Text(
                        'Year',
                        style: TextStyle(
                            color: Colors.black54,
                            // fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 40, right: 90),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1),
                      ),
                      child: DropdownButton<Category>(
                        isExpanded: true,
                        hint: Text('    ---', style: TextStyle(fontSize: 30)),
                        underline: SizedBox.shrink(),
                        value: year,
                        onChanged: (cat) {
                          setState(() {
                            year = cat;
                            department = null;
                            subject = null;
                            departmentList.clear();
                            subjectList.clear();
                          });
                          _setDepartmentList(cat.id);
                        },
                        items: yearList.map<DropdownMenuItem<Category>>(
                            (Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Text(
                        'Department',
                        style: TextStyle(
                            color: Colors.black54,
                            // fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 40, right: 90),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1),
                      ),
                      child: DropdownButton<Category>(
                        isExpanded: true,
                        hint: Text('    ---', style: TextStyle(fontSize: 30)),
                        underline: SizedBox.shrink(),
                        value: department,
                        onChanged: (cat) {
                          setState(() {
                            department = cat;
                            subject = null;
                            subjectList.clear();
                          });
                          _setSubjectList(cat.id);
                        },
                        items: departmentList.map<DropdownMenuItem<Category>>(
                            (Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Text(
                        'Subject',
                        style: TextStyle(
                            color: Colors.black54,
                            // fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 40, right: 90),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1),
                      ),
                      child: DropdownButton<Category>(
                        isExpanded: true,
                        hint: Text('    ---', style: TextStyle(fontSize: 30)),
                        underline: SizedBox.shrink(),
                        value: subject,
                        onChanged: (cat) {
                          setState(() {
                            subject = cat;
                          });
                        },
                        items: subjectList.map<DropdownMenuItem<Category>>(
                            (Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          onPressed: () {
                            context.read<ResourceBloc>().add(CreateResource(
                                fileNameController.text,
                                file.path,
                                year.id,
                                department.id,
                                subject.id,
                                widget.type));
                          },
                          child: Text('Post',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ResourceCreating) {
            return Center(
              child: CircularProgressIndicator(
                value: state.progress.toDouble(),
              ),
            );
          } else {
            return Center(child: Text("State in add resource is $state"));
          }
        },
      ),
    );
  }

  void _setDepartmentList(String id) {
    departmentList = categories.where((cat) => cat.parentId == id).toList();
  }

  void _setSubjectList(String id) {
    subjectList = categories.where((cat) => cat.parentId == id).toList();
  }

  Future<void> _pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: widget.type == 'image' ? ['jpg', 'png'] : ['pdf'],
    );

    if (result != null) {
      setState(() {
        file = File(result.files.single.path);
      });
    } else {
      // User canceled the picker
    }
  }
}
