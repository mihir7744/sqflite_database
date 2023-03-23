import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_database/Page1.dart';
import 'package:task_database/Page2.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

var textEditingController = TextEditingController();
var textEditingController_ = TextEditingController();
bool icons_ = true;
String img='';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          // You can use the library anywhere in the app even in theme

          home: child,
        );
      },
      child: Page0(),
    );
  }
}

class Page0 extends StatefulWidget {
  @override
  State<Page0> createState() => _Page0State();
}

class _Page0State extends State<Page0> {
  SharedPreferences? preferences;

  ThemeData _light = ThemeData(
      primarySwatch: Colors.amber,
      focusColor: Colors.amber,
      brightness: Brightness.light);
  ThemeData _dark = ThemeData(
      // primarySwatch: Colors.red,
      // focusColor: Colors.white,
      // backgroundColor: Colors.black,
      brightness: Brightness.dark);

  IconData _iconlight = Icons.mode_night_sharp;
  IconData _icondark = Icons.sunny;

  @override
  void initState() {
    syncdata();
    super.initState();
    databasehelper = Databasehelper();
  }

  Databasehelper? databasehelper;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: icons_ ? _dark : _light,
      home: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text('Data'),
          actions: [
            IconButton(
                onPressed: () async {
                  if (preferences != null) {
                    icons_ = !icons_;
                    await preferences!.setBool('key', icons_);
                  }
                  setState(() {});
                },
                icon: Icon(icons_ ? _icondark : _iconlight))
          ],
        ),
        body: FutureBuilder(
          future: Databasehelper.getData(),
          builder: (context,AsyncSnapshot<List<Datab>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Data error is ${snapshot.error.toString()}'),
              );
            } else if (snapshot.hasData) {
              if(snapshot.data != null){
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Page2(data: snapshot.data![index],),
                            )).then((value) => print("data= ========== ${snapshot.data!.length}"),
                        );
                        setState(() {
                        });
                      },
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: FileImage(new File("${snapshot.data![index].image}")),
                          ),
                          title: Text("${snapshot.data![index].name}"),
                          trailing: IconButton(onPressed: ()async{
                            await Databasehelper.deleteData(snapshot.data![index]);
                            setState(() {
                            });
                          },icon: Icon(Icons.delete)),
                          subtitle: Text("${snapshot.data![index].contect}"),
                          // subtitle: Text(snapshot.data![index].image.toString()),
                        ),
                      ),
                    );
                  },
                );
              }
            }
            return Container(color: Colors.black,);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showForm();
          },
          child: Icon(Icons.add),
        ),
      )),
      debugShowCheckedModeBanner: false,
    );
  }

  syncdata() async {
    preferences = await SharedPreferences.getInstance();
    return icons_ = await preferences!.getBool("key") ?? false;
  }



  // =============================================                         bottom sheet




  _showForm() async {

    showModalBottomSheet(
      isScrollControlled: true,

      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      clipBehavior: Clip.antiAlias,
      backgroundColor: icons_ ? Colors.black : Colors.white10,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: icons_ ? Colors.grey : Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          // height: 800,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              SizedBox(
                height: 30.h,
              ),
              GestureDetector(
                onTap: (){
                  setState(() {

                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text('Chose '),
                      actions: [
                        GestureDetector(
                            onTap: () async {
                              XFile? xFile = await ImagePicker()
                                  .pickImage(
                                  source: ImageSource.camera);
                              setState(() {
                                if (xFile != null) {
                                  img = xFile.path;
                                }
                                Navigator.pop(context);
                              });
                            },
                            child: ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Camera'),
                            )),
                        GestureDetector(
                            onTap: () async {
                              XFile? xFile = await ImagePicker()
                                  .pickImage(
                                  source: ImageSource.gallery);
                              setState(() {

                                if (xFile != null) {

                                  print("fgfgfg===${xFile.path}");


                                  img =xFile.path;
                                }
                                Navigator.pop(context);
                              });
                            },
                            child: ListTile(
                              leading: Icon(Icons.image),
                              title: Text('File'),
                            )),
                      ],
                    );
                  },);
                  });
                },
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundColor: icons_ ? Colors.cyanAccent : Colors.amber,
                  backgroundImage: img.isEmpty ? null : FileImage(new File(img)),
                ),
              ),
              // Spacer(),
              Container(
                margin: EdgeInsets.all(20),
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Name'),
                ),
              ),
              // Spacer(),
              Container(
                margin: EdgeInsets.all(20),
                child: TextField(
                  controller: textEditingController_,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Contect No'),
                  keyboardType: TextInputType.number,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Back")),
                  ElevatedButton(
                      onPressed: () async {
                        final name = textEditingController.value.text;
                        final contect = textEditingController_.value.text;

                        if (name.isEmpty || contect.isEmpty) {
                          return;
                        }

                        print("Data length========= ${Databasehelper.getData.toString()}");

                        final Datab model = Datab(
                            name: name,
                            contect: contect,
                            image: img.toString(),

                            );
                        setState(() {
                        });

                        print("data / model=====${model.name }, ${model.contect },=== ${model.id }");
                          await Databasehelper.addNote(model);

                        Navigator.pop(context);
                        // });
                      },
                      child: Text("Save")),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}


