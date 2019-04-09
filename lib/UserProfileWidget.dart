import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserProfileWidget extends StatefulWidget {
  final String userID;

  UserProfileWidget({Key key, this.userID}) : super(key: key);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  final _formKey = GlobalKey<FormState>();

  DateTime _birthDate;

  @override
  Widget build(BuildContext context) {
    var title = widget.userID != null ? "Edit User" : "New User";
    var submitText = widget.userID != null ? "Edit" : "Create";

    var birthDateText = _birthDate != null
        ? DateFormat("dd-MM-yyyy").format(_birthDate)
        : "Birth date";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "First"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "User must have a name";
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "Last"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "User must have a name";
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                          decoration: InputDecoration(hintText: birthDateText)),
                    ),
                    IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () => _selectDate(context),
                    )
                  ],
                ),
                RaisedButton(
                  child: Text(submitText),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    var isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    FocusScope.of(context).requestFocus(new FocusNode());

    if (isKeyboardOpen) await Future.delayed(Duration(milliseconds: 300));

    var newDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      initialDate: _birthDate ?? DateTime.now(),
      lastDate: DateTime.now(),
    );

    setState(() {
      _birthDate = newDate;
    });
  }
}
