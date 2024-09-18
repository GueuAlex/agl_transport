import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/app_text.dart';
import '../delivering/widgets/deli_tab_bar_view_body.dart';

class DeliSearchByDateScreen extends StatelessWidget {
  static String routeName = 'deli_search_by_date_screen';
  const DeliSearchByDateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final date = ModalRoute.of(context)!.settings.arguments as DateTime;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: AppText.medium(
          DateFormat('EEE dd MMMM yyyy', 'fr_FR').format(date),
        ),
      ),
      body: DeliTabBarViewBody(
        date: date,
        /* status: deliSearchParams.status, */
        size: size,
      ),
    );
  }
}
