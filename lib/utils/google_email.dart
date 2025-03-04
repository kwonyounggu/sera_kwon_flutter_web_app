import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class GoogleEmail 
{
  final String serviceAccountJson;
  final String senderEmail;

  GoogleEmail({required this.serviceAccountJson, required this.senderEmail});

  Future<void> sendEmail({required String to, required String subject, required String body,}) async 
  {
    try 
    {
      // ignore: no_leading_underscores_for_local_identifiers
      final _credentials = ServiceAccountCredentials.fromJson(serviceAccountJson);
      // ignore: no_leading_underscores_for_local_identifiers
      const _scopes = [GmailApi.gmailSendScope];

      final httpClient = await clientViaServiceAccount(_credentials, _scopes);
      final client = GmailApi(httpClient);

      final message = _generateMessage(to, subject, body);
  
      await client.users.messages.send(Message.fromJson(jsonDecode(message)) , 'me');
      debugPrint('Email sent to: $to');
      httpClient.close();
    } 
    catch (e) 
    {
      debugPrint('Error sending email: $e');
      rethrow; // rethrow to allow caller to handle error.
    }
  }

  String _generateMessage(String to, String subject, String body) 
  {
    final message = StringBuffer();
    message.write("From: $senderEmail\r\n");
    message.write("To: $to\r\n");
    message.write("Subject: $subject\r\n");
    message.write("Content-Type: text/plain; charset=utf-8\r\n");
    message.write("\r\n");
    message.write(body);
    final encodedMessage = base64UrlEncode(utf8.encode(message.toString()));
    debugPrint("$message --- $encodedMessage");
    return '{"raw": "$encodedMessage"}';
  }
}

// Example usage:
// Inside your flutter widget or service.
// final emailService = EmailService(
//     serviceAccountJson: r'''
//     {
//       "type": "service_account",
//       "project_id": "your-project-id",
//       "private_key_id": "your-private-key-id",
//       "private_key": "-----BEGIN PRIVATE KEY-----\nYOUR_PRIVATE_KEY\n-----END PRIVATE KEY-----\n",
//       "client_email": "your-service-account-email@your-project-id.iam.gserviceaccount.com",
//       "client_id": "your-client-id",
//       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//       "token_uri": "https://oauth2.googleapis.com/token",
//       "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//       "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/your-service-account-email%40your-project-id.iam.gserviceaccount.com"
//     }
//     ''',
//     senderEmail: 'your-service-account-email@your-project-id.iam.gserviceaccount.com');

// Future<void> _sendFormEmail() async {
//   try {
//     await emailService.sendEmail(
//       to: 'recipient@example.com',
//       subject: 'Form Submission',
//       body: 'Form data: ...',
//     );
//     // Handle success
//   } catch (e) {
//     // Handle error
//   }
// }