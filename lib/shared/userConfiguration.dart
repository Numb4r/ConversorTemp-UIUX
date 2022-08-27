import 'dart:ffi';

import 'package:hive/hive.dart';

class UserConfiguration {
  UserConfiguration({this.darkTheme = false});

  @HiveField(0)
  bool darkTheme;
}
