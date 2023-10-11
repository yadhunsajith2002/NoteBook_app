import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/view/description_screen.dart/description_screen.dart';

class NoteCard extends StatefulWidget {
  NoteCard({
    super.key,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.description,
    required this.title,
    required this.date,
    required this.color,
  });

  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;

  final String description;
  final String title;
  final String date;
  final int color;

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return DescriptionScreen(
                color: Color(widget.color),
                date: widget.date,
                description: widget.description,
                title: widget.title,
              );
            },
          ));
        },
        child: Card(
          elevation: 20,
          color: Color(widget.color),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: widget.onEditPressed,
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: widget.onDeletePressed,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(widget.description,
                        textAlign: TextAlign.justify,
                        maxLines: 4,
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.poppins(
                            color: Colors.grey.shade800, fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.date,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
