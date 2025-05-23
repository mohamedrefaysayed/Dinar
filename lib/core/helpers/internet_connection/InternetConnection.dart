// ignore_for_file: file_names, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, non_constant_identifier_names

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dinar_store/core/utils/genrall.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:flutter/material.dart';

extension InternetConnection on BuildContext {
  Future checkInternet() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      if (noConnection.value) {
        showMessageSnackBar(
          message: "online",
          color: Colors.green,
          imagePath: "assets/images/retriveConnection.svg",
        );
        noConnection.value = false;
      }
    } else {
      if (!noConnection.value) {
        showMessageSnackBar(
          message: "offline",
          color: Colors.red,
          imagePath: "assets/images/lostConnection.svg",
        );
        noConnection.value = true;
      }
    }
  }

  noConnectionMessage() {
    showMessageSnackBar(
      message: "offline",
      color: Colors.red,
      imagePath: "assets/images/lostConnection.svg",
    );
  }
}
