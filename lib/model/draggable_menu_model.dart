import 'package:flutter/material.dart';

import '../screens/delivering/deliverig_screen.dart';
import '../screens/home/home.dart';
import '../screens/in_process_delivery/in_process_delivery.dart';
import '../screens/scanner/scan_screen.dart';
import '../screens/verify_by_code/verify_by_code_screen.dart';

class DraggableMenuModel {
  final String title;
  final String subTitle;
  final String icon;
  final String route;
  final Color color;

  const DraggableMenuModel({
    required this.title,
    required this.icon,
    required this.route,
    required this.subTitle,
    required this.color,
  });

  static List<DraggableMenuModel> dragMenuList1 = [
    DraggableMenuModel(
      title: 'Scanner',
      subTitle: 'Faites vos scans de visites et livraisons',
      icon: 'assets/icons/menu/qr-scan.svg',
      route: ScanScreen.routeName,
      color: Color.fromARGB(255, 154, 5, 171),
    ),
    DraggableMenuModel(
      title: 'Code',
      subTitle: 'Vérifier les accès par code',
      icon: 'assets/icons/menu/binary.svg',
      route: VerifyByCodeSheet.routeName,
      color: Color.fromARGB(255, 1, 88, 120),
    ),
  ];
  static List<DraggableMenuModel> dragMenuList2 = [
    DraggableMenuModel(
      title: 'Vos Stats',
      subTitle: 'Une vue d\'ensemble de vos statistiques',
      icon: 'assets/icons/menu/chart-histogram.svg',
      route: 'StatsScreen',
      color: Color.fromARGB(255, 0, 178, 163),
    ),
    DraggableMenuModel(
      title: 'Visite',
      subTitle: 'Créer une nouvelle visite',
      icon: 'assets/icons/menu/ticket.svg',
      route: 'CreateVisitScreen',
      color: Color.fromARGB(255, 74, 0, 108),
    ),
    DraggableMenuModel(
      title: 'Visites',
      subTitle: 'Historique des visites',
      icon: 'assets/icons/menu/users-alt.svg',
      route: Home.routeName,
      color: Color(0xFF1e3799),
    ),
    DraggableMenuModel(
      title: 'Livraison',
      subTitle: 'Créer une nouvelle livraison',
      icon: 'assets/icons/menu/person-carry-box.svg',
      route: 'CreateDeliveryScreen',
      color: Color.fromARGB(255, 255, 0, 221),
    ),
    DraggableMenuModel(
      title: 'En cours',
      subTitle: 'Toutes les livraisons en cours',
      icon: 'assets/icons/menu/shipping-fast.svg',
      route: InProcessDelivery.routeName,
      color: Color(0xFF1f306e),
    ),
    DraggableMenuModel(
      title: 'Livraisons',
      subTitle: 'Vos historique de livraisons',
      icon: 'assets/icons/menu/boxes.svg',
      route: DeliveringScreen.routeName,
      color: Color.fromARGB(255, 0, 148, 178),
    ),
  ];
}
