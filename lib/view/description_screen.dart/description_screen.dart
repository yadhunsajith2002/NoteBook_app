import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionScreen extends StatefulWidget {
  DescriptionScreen(
      {super.key,
      required this.title,
      required this.description,
      required this.date,
      required this.color});

  final String title;
  final String description;
  final String date;
  final Color color;

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(widget.title,
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Text(widget.description,
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                    color: Colors.grey.shade800, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
