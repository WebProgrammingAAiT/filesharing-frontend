import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resourcify/bloc/add_resource/add_resource_bloc.dart';
import 'package:resourcify/models/models.dart';

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
    context.read<AddResourceBloc>().add(AddResourceInitialize());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${widget.type}'),
        centerTitle: true,
      ),
      body: BlocConsumer<AddResourceBloc, AddResourceState>(
        listener: (context, state) {
          print(state);
          if (state is AddResourceError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is ResourceCreated) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is AddResourceInitial) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Center(
                child: ListView(
                  children: [
                    _buildUploadContainer(),
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
                            // color: Colors.black54,
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
                          hintText: '---',
                          fillColor: Colors.grey[700],
                          // contentPadding: EdgeInsets.only(top: 14, left: 10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _BuildDropdownWidget(
                      title: 'Year',
                      value: year,
                      categoryList: yearList,
                      onSelected: (cat) {
                        setState(() {
                          year = cat;
                          department = null;
                          subject = null;
                          departmentList.clear();
                          subjectList.clear();
                        });
                        _setDepartmentList(cat.id);
                      },
                    ),
                    _BuildDropdownWidget(
                      title: 'Department',
                      value: department,
                      categoryList: departmentList,
                      onSelected: (cat) {
                        setState(() {
                          department = cat;
                          subject = null;
                          subjectList.clear();
                        });
                        _setSubjectList(cat.id);
                      },
                    ),
                    _BuildDropdownWidget(
                      title: 'Subject',
                      value: subject,
                      categoryList: subjectList,
                      onSelected: (cat) {
                        setState(() {
                          subject = cat;
                        });
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    _buildButtons(context),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            );
          } else if (state is AddResourceLoading) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Uploading'),
                  SizedBox(
                    width: 20,
                  ),
                  CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text("State in add resource is $state"));
          }
        },
      ),
    );
  }

  Container _buildUploadContainer() {
    return Container(
      height: 300,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey[400], width: 1),
        // color: Colors.white,
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
    );
  }

  Row _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RaisedButton(
          color: Colors.grey,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
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
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          onPressed: () {
            if (fileNameController.text.trim().isNotEmpty &&
                file != null &&
                year != null &&
                department != null &&
                subject != null) {
              context.read<AddResourceBloc>().add(CreateResource(
                  fileNameController.text,
                  file.path,
                  year.id,
                  department.id,
                  subject.id,
                  widget.type));
            } else {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please enter the required fields'),
                ),
              );
            }
          },
          child:
              Text('Post', style: TextStyle(fontSize: 16, color: Colors.white)),
        )
      ],
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

class _BuildDropdownWidget extends StatelessWidget {
  final String title;
  final Category value;
  final List<Category> categoryList;
  final Function onSelected;

  const _BuildDropdownWidget(
      {Key key, this.title, this.value, this.onSelected, this.categoryList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Text(
            title,
            style: TextStyle(
                // color: Colors.black54,
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
            value: value,
            onChanged: onSelected,
            items: categoryList
                .map<DropdownMenuItem<Category>>((Category category) {
              return DropdownMenuItem<Category>(
                value: category,
                child: Text(category.name),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
