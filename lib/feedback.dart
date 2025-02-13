import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mail_sender.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  // Function to send email
  Future<void> _sendFeedback() async {
    try {
      sendMail("feedback");
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending feedback")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        // This makes the content scrollable
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "We'd love to hear from you!",
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Have questions, feedback, or ideas? Let us know below!",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              SizedBox(height: 20),
              // Send Feedback Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.send),
                  label: Text("Send Feedback"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(15),
                    textStyle: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _sendFeedback,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
