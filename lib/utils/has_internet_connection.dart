import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> hasInternetConnection() async {
  final List<ConnectivityResult> connectivityResult =
      await Connectivity().checkConnectivity();

  // ✅ Check if ANY active connection exists
  final hasConnection = !connectivityResult.contains(ConnectivityResult.none);

  return hasConnection;
}
