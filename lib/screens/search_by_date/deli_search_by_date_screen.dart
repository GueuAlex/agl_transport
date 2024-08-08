import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/app_text.dart';
import '../delivering/widgets/deli_tab_bar_view_body.dart';
import '../in_process_delivery/in_process_delivery.dart';

class DeliSearchByDateScreen extends StatelessWidget {
  static String routeName = 'deli_search_by_date_screen';
  const DeliSearchByDateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deliSearchParams =
        ModalRoute.of(context)!.settings.arguments as DeliSearchParams;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: AppText.medium(
          DateFormat('EEE dd MMMM yyyy', 'fr_FR').format(deliSearchParams.date),
        ),
      ),
      body: DeliTabBarViewBody(
        date: deliSearchParams.date,
        status: deliSearchParams.status,
        size: size,
      ),
    );
  }
}
