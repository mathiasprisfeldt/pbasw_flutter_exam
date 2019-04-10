import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pbasw_flutter_exam/TabsWidget.dart';
import 'package:pbasw_flutter_exam/builders/UserCard.dart';
import 'package:pbasw_flutter_exam/services/UserService.dart';
import 'package:pbasw_flutter_exam/types/User.dart';

class UsersWidget extends TabPageWidget {
  final UserService userService = UserService();

  UsersWidget({Key key})
      : super(key: key, fabIcon: Icons.add, onFabPressed: OnFabPressedEvent());

  @override
  _UsersWidgetState createState() => _UsersWidgetState();
}

class _UsersWidgetState extends State<UsersWidget> {
  @override
  void initState() {
    super.initState();
    widget.onFabPressed?.addListener(onFabPressed);
  }

  @override
  void dispose() {
    super.dispose();
    widget.onFabPressed?.removeListener(onFabPressed);
  }

  void onFabPressed() {
    Navigator.of(context).pushNamed("/user");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.userService.getUserSnapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Center(child: Text("Failed to load users"));

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return new ListView(
            children: snapshot.data.documents
                .map((val) => buildUserCard(context, User.fromJson(val.data),
                    userId: val.documentID, userService: widget.userService))
                .toList(),
          );
        }
      },
    );
  }
}
