
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:return_success_or_error/return_success_or_error.dart';

class WidgetsFlutterBindingService extends GetxService {
  Future<Unit> init() async{
    WidgetsFlutterBinding.ensureInitialized();
    return Future.value(unit);
  }
}
