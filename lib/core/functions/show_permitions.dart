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
    await Permission.location.request();
  }
  bool locationWhenInUse = await Permission.locationWhenInUse.status.isGranted;
  if (!locationWhenInUse) {
    await Permission.locationWhenInUse.request();
  }
}
