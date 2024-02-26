

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';


void main() {
  test("test", () async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    print(appDocDir.path);
  });
}
