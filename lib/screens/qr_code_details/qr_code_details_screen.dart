import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

import '../../config/app_text.dart';
import '../../config/palette.dart';
import '../../model/order_by_date_and_hours.dart';
import '../../model/scan_history_model.dart';
import '../../model/user.dart';
import '../../model/visite_model.dart';
import '../scanner/widgets/infos_column.dart';
import 'widgets/deatils.dart';
import 'widgets/detail_header.dart';

class QrCodeDetailsScreen extends StatelessWidget {
  static String routeName = 'qr_code_details_screen';
  const QrCodeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final visite = ModalRoute.of(context)!.settings.arguments as VisiteModel;
    final User user = User(
      id: visite.id,
      genre: visite.genre,
      nom: visite.nom,
      prenoms: visite.prenoms,
      entreprise: visite.entreprise,
      numeroCni: visite.numeroCni,
      plaqueVehicule: visite.plaqueVehicule,
      email: visite.email,
      number: visite.number,
      entrepotVisite: "",
      motifVisite: visite.motif.libelle,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Platform.isIOS
                ? CupertinoIcons.chevron_back
                : CupertinoIcons.arrow_left,
            color: Palette.whiteColor,
          ),
        ),
        backgroundColor: Palette.primaryColor,
        title: AppText.medium(
          'Détails',
          color: Palette.whiteColor,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Palette.primaryColor,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  DetailsHeader(
                    user: user,
                    visite: visite,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  DetailsHeader(
                    isQrcodeInfos: true,
                    user: user,
                    visite: visite,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: InfosColumn(
                label: 'Historique',
                widget: AppText.medium('Historiques des scans'),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ScanHistoryModel>>(
                future: getThisQrCodeScanHistory(qrCodeId: visite.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: AppText.medium('Erreur : ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: AppText.medium('Aucun historique de scan trouvé.'),
                    );
                  } else {
                    final List<ScanHistoryModel> scanList = snapshot.data!;
                    List<OrderByDateAndHours<ScanHistoryModel>> data =
                        getDataByDate(scanList: scanList);

                    return SingleChildScrollView(
                      child: Column(
                        children: data
                            .map(
                              (e) => GFAccordion(
                                titleChild: AppText.medium(
                                  dateFormateur(dateTime: e.date),
                                ),
                                contentChild: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        2, // Nombre d'éléments par ligne
                                    childAspectRatio: 3.6,
                                  ),
                                  itemCount: e.data.length,
                                  itemBuilder: (context, index) {
                                    return Details(
                                      scanHistoryModel: e.data[index],
                                    );
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction asynchrone pour obtenir l'historique de scan d'un QR code
  Future<List<ScanHistoryModel>> getThisQrCodeScanHistory(
      {required int qrCodeId}) async {
    List<ScanHistoryModel> scanList = [];
    List<ScanHistoryModel> allScanHistories =
        await ScanHistoryModel.scanHistories;

    for (var element in allScanHistories) {
      if (element.visiteId == qrCodeId) {
        scanList.add(element);
      }
    }

    return scanList;
  }

  // Filtrer l'historique de scan d'un QR code et ordonner par date et heure
  List<OrderByDateAndHours<ScanHistoryModel>> getDataByDate({
    required List<ScanHistoryModel> scanList,
  }) {
    scanList.sort((a, b) {
      final dateComparison = b.scandDate.compareTo(a.scandDate);
      if (dateComparison != 0) {
        return dateComparison;
      } else {
        return a.scanHour.compareTo(b.scanHour);
      }
    });

    List<OrderByDateAndHours<ScanHistoryModel>> data = [];
    DateTime currentDate = DateTime(0);

    for (var scan in scanList) {
      if (!isSameDay(scan.scandDate, currentDate)) {
        currentDate = scan.scandDate;
        OrderByDateAndHours<ScanHistoryModel> orderByDateAndHours =
            OrderByDateAndHours<ScanHistoryModel>(data: [], date: currentDate);
        data.add(orderByDateAndHours);
      }
      data.last.data.add(scan);
    }

    return data;
  }

  // Comparaison de date
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Formatage de date
  String dateFormateur({required DateTime dateTime}) {
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    if (isSameDay(dateTime, today)) {
      return "Aujourd'hui";
    }
    if (isSameDay(today.subtract(const Duration(days: 1)), dateTime)) {
      return "Hier";
    }

    if (today.month == dateTime.month) {
      return DateFormat("EEEE \u2022 dd", 'fr_FR').format(dateTime);
    }
    return DateFormat("EEE dd MMM yyyy", 'fr_FR').format(dateTime);
  }
}
