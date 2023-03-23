import 'dart:io';

import 'package:flutter/material.dart';
import 'package:task_database/Page1.dart';
import 'package:task_database/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Page2 extends StatefulWidget {
  final Datab? data;

  const Page2({this.data});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  var textname = TextEditingController();
  var textcontect = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("${widget.data!.name}"),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              // popupmenu item 1
              PopupMenuItem(
                value: 1,

                // row has two child icon and text.
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(
                      // sized box with width 10
                      width: 10,
                    ),
                    Text("Edit")
                  ],
                ),
              ),
              // popupmenu item 2
              PopupMenuItem(
                value: 2,
                // row has two child icon and text
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(
                      // sized box with width 10
                      width: 10,
                    ),
                    Text("Delete")
                  ],
                ),
              ),
            ],
            offset: Offset(5, 65),
            onSelected: (value) {
              if (value == 2) {
                setState(() async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Delete contact?'),
                        content:
                            Text('This contact will be removed from devices.'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                Databasehelper.deleteData(widget.data!);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyApp(),
                                    ));
                              },
                              child: Text('Delete')),
                        ],
                      );
                    },
                  );
                });
              } else if (value == 1) {
                setState(() {
                  editcontect();

                  if (widget.data != null) {
                    textname.text = widget.data!.name;
                    textcontect.text = widget.data!.contect;
                  }

                  // Databasehelper.updateItem();
                });
              }
              return;
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.60,
          width: MediaQuery.of(context).size.width * 0.75,
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: FileImage(new File("${widget.data!.image}")),
              ),
              Text("${widget.data!.id}"),
              Text("${widget.data!.name}"),
              Text("${widget.data!.contect}"),
            ],
          ),
        ),
      ),
    ));
  }

  editcontect() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.65,
            child: Column(
              children: [
                Spacer(),
                Text(
                  "Edit contact",
                  style: TextStyle(fontSize: 25.sm),
                ),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: textname,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('New name'),
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: textcontect,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('New contact'),
                        prefixIcon: Icon(Icons.add),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 2,
                  child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                          onPressed: () async {
                            final name = textname.value.text;
                            final contect = textcontect.value.text;

                            final Datab model = Datab(
                                name: name,
                                contect: contect,
                                );

                            if (widget.data != null) {
                              Databasehelper.updateItem(model).then((value) {
                                setState(() {});
                              });
                              print("==========$model");
                            } else {
                              return;
                            }

                            widget.data!.name = textname.text;
                            widget.data!.contect = textcontect.text;
                            setState(() {});

                            Navigator.pop(context);

                            // setState(()  {
                            // });
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(fontSize: 17.sm),
                          ))),
                ),
                Spacer(
                  flex: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
