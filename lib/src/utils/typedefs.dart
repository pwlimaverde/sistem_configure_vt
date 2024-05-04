import 'package:flutter/material.dart';
import 'package:return_success_or_error/return_success_or_error.dart';

import '../modules/core/service/feature/connectivity/domain/model/check_connect_model.dart';

typedef WidService = UsecaseBaseCallData<Unit, WidgetsBinding>;
typedef WidServiceData = Datasource<WidgetsBinding>;

typedef ConnectService
    = UsecaseBaseCallData<Stream<CheckConnectModel>, Stream<ConnectStatus>>;

typedef ConnectStatus = ({
  bool connect,
  String typeConect,
});

typedef ConnectServiceData = Datasource<Stream<ConnectStatus>>;
