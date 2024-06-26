import 'package:permission_handler/permission_handler.dart';

showPermissions() async {
  ///Notifications
  bool notificationsIsGranted = await Permission.notification.status.isGranted;
  if (!notificationsIsGranted) {
    notificationsIsGranted = await Permission.notification.request().isGranted;
  }

  /////locations

  bool locationsIsGranted = await Permission.location.status.isGranted;
  if (!locationsIsGranted) {
    locationsIsGranted = await Permission.location.request().isGranted;
  }
}
