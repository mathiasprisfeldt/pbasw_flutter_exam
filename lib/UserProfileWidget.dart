import 'package:flutter/material.dart';
import 'package:pbasw_flutter_exam/services/UserService.dart';
import 'package:pbasw_flutter_exam/types/User.dart';
import 'helpers/DateHelper.dart';

class UserProfileWidget extends StatefulWidget {
  final UserService userService = UserService();

  UserProfileWidget({Key key}) : super(key: key);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  static const _firstLastFieldSpacing = 4.0;
  final _keyboardCloseDelay = 100;
  final _minDate = DateTime(
      2); // Has to be after year 1 because of Firestore Timestamp time constraints
  final _formKey = GlobalKey<FormState>();

  User user; // The user object the form makes changes to.

  String title = "User Profile";
  String submitText = "Submit";

  TextEditingController _birthDateField = TextEditingController();

  bool get userExisting => user.name?.first != null;

  // Focus nodes
  FocusNode lastNameNode = FocusNode();
  FocusNode birthDateNode = FocusNode();
  FocusNode computerNode = FocusNode();

  bool isSubmitting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Use existant user if navigated from named route with user id as argument.
    var existingUser = ModalRoute.of(context).settings.arguments;
    if (user == null) {
      user = existingUser != null ? existingUser : User.empty();
    }

    title = userExisting ? "Editing ${user.name.first}" : "New User";
    submitText = userExisting ? "Edit" : "Create";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Builder(
          builder: (context) {
            if (isSubmitting) {
              return CircularProgressIndicator();
            } else {
              return buildForm(context);
            }
          },
        ),
      ),
    );
  }

  SingleChildScrollView buildForm(BuildContext context) {
    if (user?.dob?.date != null && _birthDateField.text.isEmpty) {
      _birthDateField.text = DateHelper.format(user.dob.date);
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  /*
                      First name field
                     */
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: _firstLastFieldSpacing),
                      child: TextFormField(
                        initialValue: user?.name?.first,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(labelText: "First"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "First name is required";
                          } else {
                            user.name.first = value;
                          }
                        },
                        onFieldSubmitted: (res) {
                          FocusScope.of(context).requestFocus(lastNameNode);
                        },
                      ),
                    ),
                  ),
                  /*
                      Last name field
                     */
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: _firstLastFieldSpacing),
                      child: TextFormField(
                        initialValue: user?.name?.last,
                        textInputAction: TextInputAction.next,
                        focusNode: lastNameNode,
                        decoration: InputDecoration(labelText: "Last"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Last name is required";
                          } else {
                            user.name.last = value;
                          }
                        },
                        onFieldSubmitted: (res) {
                          FocusScope.of(context).requestFocus(birthDateNode);
                        },
                      ),
                    ),
                  )
                ],
              ),
              /*
                  Birth date Field
                 */
              TextFormField(
                textInputAction: TextInputAction.next,
                focusNode: birthDateNode,
                keyboardType: TextInputType.datetime,
                controller: _birthDateField,
                decoration: InputDecoration(
                    hintText: "Ex. ${DateHelper.format(DateTime.now())}",
                    labelText: "Birth date",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () => _selectDate(context),
                    )),
                validator: (value) {
                  try {
                    var newDate = DateHelper.parse(value);

                    if (newDate.isBefore(_minDate))
                      return "Date must be after year second";

                    if (newDate.isAfter(DateTime.now()))
                      return "Date has to be before today";

                    _birthDateField.text = DateHelper.format(newDate);
                    user.dob.date = newDate;
                  } catch (e) {
                    return "Must be a valid date";
                  }
                },
                onFieldSubmitted: (res) {
                  FocusScope.of(context).requestFocus(computerNode);
                },
              ),
              /*
                  Computer field
                 */
              TextFormField(
                initialValue: user?.computer,
                textInputAction: TextInputAction.done,
                focusNode: computerNode,
                decoration: InputDecoration(
                    labelText: "Computer", hintText: "Ex. MacBook Pro 2019"),
                validator: (value) {
                  user.computer = value;
                },
                onFieldSubmitted: (res) => onSubmitPressed(context),
              ),
              /*
                  Submit field
                 */
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  colorBrightness: Brightness.dark,
                  child: Text(submitText),
                  onPressed: () => onSubmitPressed(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onSubmitPressed(BuildContext context) {
    if (_formKey.currentState.validate()) {
      setState(() {
        isSubmitting = true;
      });

      widget.userService.updateUser(user.id, user).then((val) {
        Navigator.pop(context);
      });
    }
  }

  void _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    // Done to prevent dialog keyboard overflow because Flutter doesn't handle this.
    await Future.delayed(Duration(milliseconds: _keyboardCloseDelay));

    var newDate = await showDatePicker(
      context: context,
      firstDate: _minDate,
      initialDate: user.dob?.date ?? DateTime.now(),
      lastDate: DateTime.now(),
    );

    // If the user pressed cancel and diden't select a date.
    if (newDate == null) return;

    setState(() {
      user.dob?.date = newDate;
      _birthDateField.text = DateHelper.format(newDate);
    });
  }
}
