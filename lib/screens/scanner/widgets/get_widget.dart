import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scanner/model/agent_model.dart';

import '../../../config/functions.dart';
import '../../../model/visite_model.dart';
import 'check_visite_status.dart';
import 'date_exeption.dart';
import 'date_expiree.dart';
import 'inactif_qrcode.dart';
import 'outside_access_hours.dart';

Widget getWidget({
  required VisiteModel visite,
  required AgentModel agent,
  required BuildContext context,
}) {
  // Date actuelle
  DateTime today = DateTime.now();
  //String currentDay = today.weekday.toString(); // Lundi = 1, Dimanche = 7
  TimeOfDay currentHour = TimeOfDay.now(); // Heure actuelle

  // Définir les plages horaires pour les prestataires et clients
  TimeOfDay clientStartTime = TimeOfDay(hour: 6, minute: 0);
  TimeOfDay clientEndTime = TimeOfDay(hour: 22, minute: 0);
  TimeOfDay prestataireStartTime = TimeOfDay(hour: 7, minute: 0);
  TimeOfDay prestataireEndTime = TimeOfDay(hour: 18, minute: 0);
  TimeOfDay visiteurVisiteTime =
      Functions.stringToTimeOfDay(visite.heureVisite ?? "23:00");

  print(
      '$clientStartTime\n$clientEndTime\n$prestataireStartTime\n$prestataireEndTime');

  // Formatage de la date début et fin du QR code
  DateTime dateDebut = DateTime(
    visite.dateVisite.year,
    visite.dateVisite.month,
    visite.dateVisite.day,
  );

  ////////////////////////////////////////
  /// 3. Si la date de visite est passée
  ////////////////////////////////////////
  /// 3. si la date visite est passée
  if (visite.dateFinVisite != null) {
    DateTime dateFin = DateTime(
      visite.dateFinVisite!.year,
      visite.dateFinVisite!.month,
      visite.dateFinVisite!.day,
    );
    if (dateFin.isBefore(Functions.getToday())) {
      return dateExpiree(dateFin: dateFin, context: context);
    }
  }

  if (visite.typeVisiteur.toLowerCase() == "visiteur" &&
      dateDebut.isBefore(Functions.getToday())) {
    ////////////////////////////////////////
    ///les visiteurs ont une date visite a validité unique
    /// 1. Si  la date viste est passée

    return dateExpiree(dateFin: dateDebut, context: context);
  }

  ////////////////////////////////////////
  /// 1. Si la date de visite n'est pas encore arrivée
  if (dateDebut.isAfter(Functions.getToday())) {
    return dateException(dateDebut: dateDebut, context: context);
  }

  ////////////////////////////////////////
  /// 4. Vérification des jours et heures d'accès pour les prestataires et clients
  if (visite.typeVisiteur.toLowerCase() == "client") {
    // Vérifier si c'est un jour de la semaine (lundi à vendredi)
    if (today.weekday < 6) {
      // Vérifier les heures d'accès pour le client
      if (currentHour.hour >= clientStartTime.hour &&
          currentHour.hour <= clientEndTime.hour) {
        return checkQrCodeStatus(
            visite: visite, agent: agent, context: context);
      } else {
        //String date = DateFormat('EEEE dd yyyy', 'fr').format(visite.dateVisite);
        return outsideAccessHours(
            context: context,
            text:
                'Cette visite est autorisée uniquement du lundi au vendredi  entre ${clientStartTime.format(context)} et ${clientEndTime.format(context)}');
      }
    } else {
      //String date = DateFormat('EEEE dd yyyy', 'fr').format(visite.dateVisite);
      return outsideAccessHours(
          context: context,
          text:
              'Cette visite est autorisée uniquement du lundi au vendredi  entre ${clientStartTime.format(context)} et ${clientEndTime.format(context)}'); // Week-end
    }
  } else if (visite.typeVisiteur.toLowerCase() == "prestataire") {
    //print('-------------------------> type is true');
    // Vérifier si c'est un jour de la semaine (lundi à vendredi)
    if (today.weekday < 6) {
      // print('-------------------------> day is true');
      // Vérifier les heures d'accès pour le prestataire
      if (currentHour.hour >= prestataireStartTime.hour &&
          currentHour.hour <= prestataireEndTime.hour) {
        // print('-------------------------> hours is true');
        return checkQrCodeStatus(
            visite: visite, agent: agent, context: context);
      } else {
        // String date = DateFormat('EEEE dd yyyy', 'fr').format(visite.dateVisite);
        return outsideAccessHours(
            context: context,
            text:
                'Cette visite est autorisée uniquement du lundi au vendredi  entre ${prestataireStartTime.format(context)} et ${prestataireEndTime.format(context)}');
      }
    } else {
      return outsideAccessHours(
          context: context,
          text:
              'Cette visite est autorisée uniquement du lundi au vendredi  entre ${prestataireStartTime.format(context)} et ${prestataireEndTime.format(context)}'); // Week-end
    }
  } else if (visite.typeVisiteur.toLowerCase() == "visiteur") {
    print("----------------------> is visiteur type");
    print(visiteurVisiteTime);
    if (currentHour.hour >= visiteurVisiteTime.hour) {
      return checkQrCodeStatus(
        visite: visite,
        agent: agent,
        context: context,
      );
    } else {
      String date = DateFormat('EEEE dd yyyy', 'fr').format(visite.dateVisite);
      return outsideAccessHours(
          context: context,
          text:
              'Cette visite est autorisée uniquement pour le $date à partir de ${visiteurVisiteTime.format(context)}');
    }
  }

  ////////////////////////////////////////
  /// Si le QR code n'est pas actif
  return inactifQrCode(context: context);
}
