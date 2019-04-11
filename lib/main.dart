import 'package:flutter/material.dart';
import 'package:pbasw_flutter_exam/UserProfileWidget.dart';
import 'package:pbasw_flutter_exam/RandomUsersWidget.dart';
import 'package:pbasw_flutter_exam/UsersWidget.dart';
import 'TabsWidget.dart';

const userRoute = "/user";

void main() => runApp(MaterialApp(
      title: "PBASW Flutter Exam",
      theme: ThemeData.light(),
      home: TabsWidget(
        pages: [
          TabPage(Icons.supervised_user_circle, RandomUsersWidget()),
          TabPage(Icons.face, UsersWidget())
        ],
      ),
      routes: {userRoute: (context) => new UserProfileWidget()},
    ));
