import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<UserModel?> getDataUser() async {
    Uri url = Uri.parse('https://reqres.in/api/users/2');

    var response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode != 200) {
      print("TIDAK DAPAT DATA DARI SERVER");
      return null;
    } else {
      print(response.body);
      Map<String, dynamic> data =
          (json.decode(response.body) as Map<String, dynamic>)['data'];
      return UserModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Latihan Json Serializable"),
      ),
      body: FutureBuilder<UserModel?>(
        future: getDataUser(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : snapshot.hasData
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                NetworkImage(snapshot.data!.avatar),
                          ),
                          Text("${snapshot.data!.id}"),
                          Text("${snapshot.data!.email}"),
                          Text(
                              "Name: ${snapshot.data!.first_name} ${snapshot.data!.last_name}"),
                        ],
                      ),
                    )
                  : Center(child: Text("Tidak ada Data"));
        },
      ),
    );
  }
}
