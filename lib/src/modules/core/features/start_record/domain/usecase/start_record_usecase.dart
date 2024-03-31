import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:return_success_or_error/return_success_or_error.dart';

final class StartRecordUsecase extends UsecaseBase<MethodChannel> {
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  @override
  Future<ReturnSuccessOrError<MethodChannel>> call(NoParams parameters) async {
    
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    var plataform = const MethodChannel('method.record');
    return SuccessReturn(success: plataform);
  }
}
