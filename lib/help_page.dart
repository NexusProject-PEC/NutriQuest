import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'nutriquest-support@gmail.com',
      query: 'subject=App Support&body=Describe your issue here...',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help & Support"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How can we help you?",
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // FAQ Section
            ExpansionTile(
              title: Text("Frequently Asked Questions"),
              children: [
                ListTile(
                  title: Text("How do I scan a barcode?"),
                  subtitle: Text(
                      "Open the app, go to the scan page, and point your camera at the barcode."),
                ),
                ListTile(
                  title: Text("What do the nutrition values mean?"),
                  subtitle: Text(
                      "The app provides details on calories, proteins, carbs, and fats."),
                ),
                ListTile(
                  title: Text("How do I track my progress?"),
                  subtitle: Text(
                      "Use the Exercise page to select your weight level and get recommendations."),
                ),
              ],
            ),

            SizedBox(height: 10),

            // Troubleshooting
            ExpansionTile(
              title: Text("Troubleshooting"),
              children: [
                ListTile(
                  title: Text("App is not scanning barcodes"),
                  subtitle:
                      Text("Ensure camera permission is enabled in settings."),
                ),
                ListTile(
                  title: Text("Food data is missing or incorrect"),
                  subtitle: Text(
                      "Try scanning again or report missing items via Feedback."),
                ),
                ListTile(
                  title: Text("App crashes or runs slow"),
                  subtitle:
                      Text("Update to the latest version from Play Store."),
                ),
              ],
            ),

            SizedBox(height: 10),

            // Tips Section
            ExpansionTile(
              title: Text("Tips & Best Practices"),
              children: [
                ListTile(
                  title:
                      Text("For best scanning results, ensure good lighting."),
                ),
                ListTile(
                  title: Text("Check labels carefully before consuming food."),
                ),
                ListTile(
                  title: Text(
                      "Customize exercise recommendations based on your weight."),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Contact Support Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.email),
                label: Text("Contact Support"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.all(15),
                  textStyle: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _launchEmail,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
