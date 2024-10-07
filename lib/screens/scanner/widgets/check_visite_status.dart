import 'package:flutter/material.dart';

import '../../../model/agent_model.dart';
import '../../../model/visite_model.dart';
import 'first_scan.dart';
import 'inactif_qrcode.dart';
import 'is_already_scaned.dart';

Widget checkQrCodeStatus({
  required VisiteModel visite,
  required AgentModel agent,
  required BuildContext context,
}) {
  if (visite.isActive) {
    if (!visite.isAlreadyScanned) {
      return FirstScanWidget(
        agent: agent,
        visite: visite,
      );
    } else {
      return IsAlreadyScaned(
        visite: visite,
        agent: agent,
      );
    }
  } else {
    return inactifQrCode(context: context);
  }
}
