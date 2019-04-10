import 'package:flutter/material.dart';
import 'package:pbasw_flutter_exam/helpers/DateHelper.dart';
import 'package:pbasw_flutter_exam/services/UserService.dart';
import 'package:pbasw_flutter_exam/types/User.dart';

Widget buildUserCard(BuildContext context, User user,
    {String userId, UserService userService}) {
  return Builder(
    builder: (context) {
      if (userId != null && userService != null) {
        return Dismissible(
          onDismissed: (dir) {
            userService.removeUser(userId);
          },
          direction: DismissDirection.horizontal,
          key: Key(userId),
          child: createCard(userId, context, user),
        );
      } else {
        return createCard(userId, context, user);
      }
    },
  );
}

Card createCard(String userId, BuildContext context, User user) {
  return Card(
    child: InkWell(
      onTap: userId != null
          ? () {
              Navigator.of(context)
                  .pushNamed("/user", arguments: user.withId(userId));
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
                Text(user.name.full, style: Theme.of(context).textTheme.title),
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
                  visible: user.dob != null && user.dob.date != null,
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
