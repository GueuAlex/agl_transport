import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendErrorEmail(
    {required String title,
    required String subject,
    required String errorDetails}) async {
  // Configurer le serveur SMTP de Brevo
  final username = dotenv.env['MAIL_USERNAME']!;
  final password = dotenv.env['MAIL_PASSWORD']!;
  final host = dotenv.env['MAIL_HOST']!;

  final smtpServer = SmtpServer(
    host,
    port: 587, // Ou 465 si tu utilises SSL
    username: username,
    password: password,
  );

  // Créer l'e-mail
  final message = Message()
    ..from = Address(username, 'AGL - Alert System') // Nom d'expéditeur
    ..recipients.add('mohamed.karamoko@digifaz.com')
    ..recipients.add('klagueu@gmail.com') // Destinataire
    ..recipients.add('alexandre.kla@digifaz.com')
    ..subject = subject
    ..text = '$title $errorDetails';

  try {
    final sendReport = await send(message, smtpServer);
    print('Alerte e-mail envoyée : ${sendReport.toString()}');
  } on MailerException catch (e) {
    print('Erreur lors de l\'envoi de l\'e-mail : $e');
    for (var p in e.problems) {
      print('Problème : ${p.code}: ${p.msg}');
    }
  }
}
