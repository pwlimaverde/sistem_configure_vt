
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetsFlutterBindingService extends GetxService {
  Future<WidgetsBinding> init() async {
    final widgetsFlutterBinding = WidgetsFlutterBinding.ensureInitialized();
    return widgetsFlutterBinding;
  }
}
