import 'package:connectivity_plus/connectivity_plus.dart';

class DataConnection {
  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network  or  to a wifi network.
      return true;
    } else {
      return false;
    }
  }
}
