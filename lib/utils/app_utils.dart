import 'package:flutter/foundation.dart';

class AppUtils {
  static void printLog(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }

}
