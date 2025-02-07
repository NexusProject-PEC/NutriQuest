import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 60,
                    color: Colors.green[900],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome to Nutrient Checker!",
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Our mission is to help you make healthier and more informed dietary choices by providing easy-to-use tools for checking nutrition facts.",
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: Colors.grey[800]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Introduction Section
            Text(
              "Our Story",
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              "Nutrient Checker was created to empower individuals to take control of their health by providing an easy way to scan food items and check their nutritional value. Whether you're looking to cut down on sugar, increase your protein intake, or just make healthier food choices, we are here to help!",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
            ),

            SizedBox(height: 30),

            // Our Features Section
            Text(
              "What We Offer",
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            _buildFeatureCard(
                "Scan barcodes to get nutrition facts", Icons.qr_code_scanner),
            _buildFeatureCard(
                "Track your nutritional intake", Icons.track_changes),
            _buildFeatureCard(
                "Explore different nutrients categories", Icons.eco),
            _buildFeatureCard(
                "Get personalized exercise suggestions", Icons.fitness_center),

            SizedBox(height: 30),

            // Team Section
            Text(
              "Meet The Team",
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            // Wrap widget to arrange team members in two rows
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                _buildTeamMember(
                    "assets/normal.png", "Deva Jeshurun D C", "Founder"),
                _buildTeamMember(
                    "assets/normal.png", "Arun Pradeep", "Lead Developer"),
                _buildTeamMember(
                    "assets/normal.png", "Akash Raj", "Marketing Strategist"),
                _buildTeamMember(
                    "assets/normal.png", "Aadhi Rajan", "Marketing Strategist"),
              ],
            ),

            SizedBox(height: 30),

            // Contact Us Section
            Text(
              "Get in Touch",
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              "Have questions or feedback? We'd love to hear from you! Feel free to contact us through email or follow us on social media.",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Feature card widget
  Widget _buildFeatureCard(String featureText, IconData featureIcon) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(featureIcon, size: 40, color: Colors.green),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                featureText,
                style:
                    GoogleFonts.poppins(fontSize: 16, color: Colors.grey[800]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Team member card widget
  Widget _buildTeamMember(String imagePath, String name, String role) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(height: 10),
        Text(
          name,
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          role,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
