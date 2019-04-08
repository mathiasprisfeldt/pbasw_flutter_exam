import 'package:flutter/material.dart';
import 'package:pbasw_flutter_exam/types/User.dart';
import 'package:pbasw_flutter_exam/services/RandomUserService.dart';

class UsersWidget extends StatefulWidget {
  final RandomUserService randomUserService = RandomUserService();

  @override
  _UsersWidgetState createState() => _UsersWidgetState();
}

class _UsersWidgetState extends State<UsersWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.randomUserService.getUsers(50),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          return ListView(
              children: snapshot.data
                  .map((user) => buildUserEntry(context, user))
                  .toList());
        }
      },
    );
  }

  Widget buildUserEntry(BuildContext context, User user) {
    return Card(
      child: Row(
        children: <Widget>[Text("${user.name.first} ${user.name.last}")],
      ),
    );
  }
}
