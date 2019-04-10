import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pbasw_flutter_exam/helpers/DateHelper.dart';

class User {
  String id;
  Name name = Name();
  DOB dob = DOB();
  Picture picture = Picture();
  String phone;
  String computer;

  User(DOB dob, Picture picture, String phone, String computer)
      : this.dob = dob,
        this.picture = picture,
        this.phone = phone,
        this.computer = computer;

  User.empty() {
    this.name = Name();
    this.dob = DOB();
    this.picture = Picture();
  }

  User.fromJson(Map data)
      : this.name = Name.fromJson(data['name']),
        this.dob = DOB.fromJson(data['dob']),
        this.picture = Picture.fromJson(data['picture']),
        this.phone = data['phone'],
        this.computer = data['computer'];

  Map<String, dynamic> toJson() => {
        "name": name?.toJson(),
        "dob": dob?.toJson(),
        "picture": picture?.toJson(),
        "phone": phone,
        "computer": computer
      };

  User withId(String userId) {
    this.id = userId;
    return this;
  }
}

class Name {
  String title;
  String first;
  String last;

  Name({String title, String first, String last})
      : this.title = title,
        this.first = first,
        this.last = last;

  Name.fromJson(Map data) {
    if (data == null) return;

    this.title = data['title'];
    this.first = data['first'];
    this.last = data['last'];
  }

  Map<String, dynamic> toJson() =>
      {"title": title, "first": first, "last": last};

  String get initials => first.substring(0, 1) + last.substring(0, 1);

  String get full => "$first $last";
}

class DOB {
  DateTime _date;
  int age;

  set date(DateTime date) {
    if (date == null) return;

    this._date = date;
    this.age = DateHelper.yearsOld(date);
  }

  DateTime get date => _date;

  DOB({DateTime date, int age}) {
    this.date = date;
    if (age != null) this.age = age;
  }

  DOB.fromJson(Map data) {
    if (data == null) return;

    var date = data['date'];
    if (date is Timestamp) {
      this.date =
          DateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch);
    } else {
      this.date = DateTime.parse(date);
    }

    this.age = data['age'];
  }

  Map<String, dynamic> toJson() => {"date": date, "age": age};
}

class Picture {
  String large;
  String medium;
  String thumbnail;

  Picture({String large, String medium, String thumbnail})
      : this.large = large,
        this.medium = medium,
        this.thumbnail = thumbnail;

  Picture.fromJson(Map data) {
    if (data == null) return;

    this.large = data['large'];
    this.medium = data['medium'];
    this.thumbnail = data['thumbnail'];
  }

  Map<String, dynamic> toJson() =>
      {"large": large, "medium": medium, "thumbnail": thumbnail};
}
