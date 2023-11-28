import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class DescriptionScreen extends StatefulWidget {
  DescriptionScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.date,
    this.imagePaths = const [],
  }) : super(key: key);

  final String title;
  final String description;
  final String date;
  final List<String> imagePaths;

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () {
                String message = widget.description;
                String subject = widget.title;
                Share.share(message, subject: subject);
              },
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(widget.title,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(widget.description,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                      color: Colors.grey.shade300, fontSize: 16)),
              SizedBox(height: 20),
              // Display images at the bottom
              if (widget.imagePaths.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attached Images',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.imagePaths.length,
                        itemBuilder: (context, index) {
                          File imageFile = File(widget.imagePaths[index]);

                          if (imageFile.existsSync()) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                imageFile,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
