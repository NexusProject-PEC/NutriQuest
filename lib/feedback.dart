import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Function to send email
  Future<void> _sendFeedback() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    final smtpServer = gmail('devajeshurun57@gmail.com', 'zjyv rtwp eyzz bowu');

    final message = Message()
      ..from = Address('your-email@gmail.com', 'NutriQuest')
      ..recipients.add('devajeshurun57@gmail.com')
      ..subject = 'App Feedback from ${_nameController.text}'
      ..text = _messageController.text;

    try {
      final sendReport = await send(message, smtpServer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Feedback sent successfully!")),
      );
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending feedback: $error")),
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

              // Name Field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Your Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Your Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),

              // Message Field
              TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: "Your Message",
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
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
