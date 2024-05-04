import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:return_success_or_error/return_success_or_error.dart';

import '../../../../../../utils/typedefs.dart';

///Datasources
final class ConnectivityDatasource
    implements Datasource<Stream<ConnectStatus>> {
  final Connectivity connectivity;

  ConnectivityDatasource(this.connectivity);

  @override
  Future<Stream<ConnectStatus>> call(
    NoParams parameters,
  ) async {
    try {
      final subscription = connectivity.onConnectivityChanged;
      final result = subscription.map((event) {
        if (event.contains(ConnectivityResult.none)) {
          return (connect: false, typeConect: "none");
        } else {
          final typeConect = event.contains(ConnectivityResult.wifi)
              ? "wifi"
              : event.contains(ConnectivityResult.mobile)
                  ? "moble"
                  : event.contains(ConnectivityResult.ethernet)
                      ? "ethernet"
                      : "none";
          return (connect: true, typeConect: typeConect);
        }
      });
      return result;
    } catch (e) {
      throw parameters.error..message = "$e";
    }
  }
}
