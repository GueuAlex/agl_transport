//met a jour l'historique des scans de l'api
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';

import '../../../config/functions.dart';
import '../../../remote_service/remote_service.dart';

Future<void> upDateScanHistory({
  //required String carID,
  bool isEntree = true,
  required Map<String, dynamic> scanHistoryData,
  required BuildContext context,
}) async {
  //Get.back();
  Navigator.pop(context);
  EasyLoading.show();
  // print(scanHistoryData);
  //Functions.showLoadingSheet(ctxt: context);
  ///////////////////////////////////
  /// update via APIs here
  await RemoteService()
      .postData(
    endpoint: 'scanCounters',
    postData: scanHistoryData,
  )
      .whenComplete(() {
    EasyLoading.dismiss();
    Get.back();

    Functions.showToast(
      msg: isEntree ? 'Entrée enregistrée !' : 'Sortie enregistrée !',
      gravity: ToastGravity.TOP,
    );
  });
}
