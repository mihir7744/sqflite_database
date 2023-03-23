import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Datab {
  Datab({
    this.id,
    required this.name,
    required this.contect,
    this.image,
  });

  int? id;
  String name;
  String contect;
  String? image;

  factory Datab.fromJson(Map<String, dynamic> json) => Datab(
      id: json["id"],
      name: json["name"],
      contect: json["contect"],
      image: json["image"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "contect": contect,
        "image": image,
      };
}

class Databasehelper {
  static Future<Database?> init() async {
    var path = await getDatabasesPath();
    path = join(path, "database.db");

    return openDatabase(path,
        version: 1,
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE Data(id INTEGER PRIMARY KEY, name TEXT NOT NULL, contect TEXT NOT NULL, image TEXT NOT NULL)"));
  }

  static Future addNote(Datab data) async {
    Database? database = await init();

    print("Data jason ==== ${data.toJson()}");

    return await database!.insert("Data", data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future updateItem(Datab data) async {
    Database? database = await init();

    return await database?.update("Data", data.toJson(),
        where: "name = ?",
        whereArgs: [data.name],
        conflictAlgorithm: ConflictAlgorithm.replace);

    // return await database?.update("Data", data.toJson(),
    //     where: "id = ?",
    //     whereArgs: [data.id],
    //     conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future deleteData(Datab data) async {
    Database? database = await init();

    return await database
        ?.delete("Data", where: "id = ?", whereArgs: [data.id]);
  }

  static Future<List<Datab>?> getData() async {
    Database? database = await init();
    List<Map<String, dynamic>> list = await database!.query('Data');
    if (list.isEmpty) {
      return null;
    }
    print("List length =======${list.length}");
    return List.generate(list.length, (index) => Datab.fromJson(list[index]));
  }
}

class Dhelper {
  static Future<Database?> init() async {
    var path = await getDatabasesPath();

    join(path, "database.db");

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async => await db.execute("CREATE TABLE Data(id INTEGER PRIMARY KEY, name TEXT NOT NULL, contact TEXT NOT NULL )"),
    );
  }

  static Future<List<Datab>> getData() async {
    Database? database = await init();

    List<Map<String, dynamic>> list = await database!.query("Data");

    return List.generate(list.length, (index) => Datab.fromJson(list[index]));
  }

  static Future addData(Datab datab) async {
    Database? database = await init();

    return database?.insert("Data", datab.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future upData(Datab datab) async {
    Database? database = await init();

    return database?.update(
        "Data",
        whereArgs: [datab.name],
        datab.toJson(),
        where: ("name = ?"),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

// // Future<List<Model>>
// getListin()async{
//   Database? database = await init();
//   // final List<Map<String, Object?>> list = await database!.query("database_");
//
//   final queryResult = await database!.query("");
//   inspect(queryResult);
//
//   // return list.map((e) => Model.fromJson(e)).toList();
// }
//
// static deleteData() async {
//   Database? database = await init();
//
//   if (database != null) {
//     await database.delete("database_",
//         where: "name =?", whereArgs: ["mihir"]).then((value) {
//       print("delete ============  $value");
//     // return value;
//     });
//   }
// }
//
// static updateData() async {
//   Database? database = await init();
//
//   if (database != null) {
//     await database
//         .update("database_", {"name": "parmar"},
//             where: "name =?", whereArgs: ["bhavik"])
//         .then(
//       (value) {
//         print("updated ======= $value");
//       },
//     );
//   }
// }

// class DataHelper {
//   static Database? database;
//
//   static Future<Database?> init() async {
//     try {
//       var path = await getDatabasesPath();
//
//       print("path===$path");
//
//       path = join(path, "database.db");
//
//       print("path===$path");
//
//       var isAlreadyExist = await databaseExists(path);
//       print("isAlreadyExist===$isAlreadyExist");
//
//       if (!isAlreadyExist) {
//         await Directory(dirname(path)).create(recursive: true);
//
//         ByteData byteData =
//         await rootBundle.load(join("asset", "database.db"));
//
//         List<int> list = byteData.buffer
//             .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
//
//         new File(path).writeAsBytes(list, flush: true);
//       }
//
//       database = await openDatabase(
//         path,
//         version: 1,
//         onCreate: (db, version) {},
//       );
//
//       return database;
//     } catch (e) {}
//
//     return null;
//   }
//
//   static getAllData() async {
//     Database? database = await init();
//
//     print("database==$database");
//
//     if (database != null) {
//       await database.query("database_").then((value) {
//         print("value==${value.length}");
//
//         List list = value;
//
//         list.forEach((element) {
//           print("element==${element}");
//         });
//       });
//       // print("list===${res.length}");
//     }
//   }
//
//   static Future<void> insertData() async {
//     Database? database = await init();
//
//     print("database==$database");
//
//     if (database != null) {
//       await database.insert("database_", {"name": "Student 1","contect":6548965432,}).then((value) {
//         print("value==$value");
//       });
//     }
//   }
//
//   static Future<void> updateData() async {
//     Database? database = await init();
//
//     print("database==$database");
//
//     if (database != null) {
//       await database
//           .update("database_", {"name": "mihir"},
//           where: "name=?",
//           whereArgs: [
//             "Student 4",
//           ])
//           .then((value) {
//         print("value==$value");
//       });
//     }
//   }
//
//   static Future<void> deleteData() async {
//     Database? database = await init();
//
//     print("database==$database");
//
//     if (database != null) {
//       // await database.delete('student 1', where: 'id = ?',whereArgs: [9]);
//
//       await database
//           .delete("database_", where: "id =?", whereArgs: [14]).then((value) {
//         print("value==$value");
//       });
//     }
//   }
// }
