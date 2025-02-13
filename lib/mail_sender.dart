import 'package:url_launcher/url_launcher.dart';
void sendMail(String context) async {
  final String mail = "devajeshurun45@gmail.com";
  final String subject;
  switch(context){
    case "feedback":
    subject = "Feedback_about_the_app";
    break;
    case "support":
    subject = "Support_for_the_issue";
    break;
    default:
    subject = "NutriQuest Contact";
  }
  final Uri emailUri = Uri(scheme: 'mailto',path: mail,queryParameters: {
    'subject' : subject,
  },);
  if (await launchUrl(emailUri)){
  }else{
    throw "Error can't launch Gmail";
  }
}
