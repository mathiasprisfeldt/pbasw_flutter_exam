import 'package:flutter/material.dart';
import 'package:pbasw_flutter_exam/helpers/DateHelper.dart';
import 'package:pbasw_flutter_exam/services/UserService.dart';
import 'package:pbasw_flutter_exam/types/User.dart';

Widget buildUserCard(BuildContext context, User user,
    {String userId, UserService userService}) {
  return Dismissible(
    onDismissed: (dir) {
      if (userService != null) userService.removeUser(userId);
    },
    direction: userService != null ? DismissDirection.horizontal : null,
    key: Key(userId),
    child: Card(
      child: InkWell(
        onTap: userId != null
            ? () {
                Navigator.of(context).pushNamed("/user", arguments: user);
              }
            : null,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                  backgroundImage: user.picture?.medium != null
                      ? NetworkImage(user.picture.medium)
                      : null,
                  minRadius: 50,
                  child: Text(user.name.initials)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(user.name.full,
                      style: Theme.of(context).textTheme.title),
                  Visibility(
                    child: Text(
                      "Tel.: ${user.phone}",
                      style: Theme.of(context).textTheme.body2,
                    ),
                    visible: user.phone != null && user.phone.isNotEmpty,
                  ),
                  Visibility(
                    child: Text(
                      "Computer: ${user.computer}",
                      style: Theme.of(context).textTheme.body2,
                    ),
                    visible: user.computer != null && user.computer.isNotEmpty,
                  ),
                  Visibility(
                    child: Text(
                      "Born: ${DateHelper.format(user.dob.date)} (${user.dob.age} years old)",
                      style: Theme.of(context).textTheme.body2,
                    ),
                    visible: user.computer != null && user.computer.isNotEmpty,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
