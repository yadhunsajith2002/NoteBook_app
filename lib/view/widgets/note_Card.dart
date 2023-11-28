import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo_app/view/description_screen.dart/description_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NoteCard extends StatefulWidget {
  NoteCard({
    super.key,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.description,
    required this.title,
    required this.date,
    this.onRightslide,
    this.onLeftslide,
  });

  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;
  final void Function(BuildContext)? onRightslide;
  final void Function(BuildContext)? onLeftslide;

  final String description;
  final String title;
  final String date;

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
                date: widget.date,
                description: widget.description,
                title: widget.title,
              );
            },
          ));
        },
        child: Slidable(
          startActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: widget.onLeftslide,
                icon: Icons.edit,
                backgroundColor: Colors.grey.shade300,
              )
            ],
          ),
          endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: widget.onRightslide,
                icon: Icons.delete,
                backgroundColor: Colors.grey.shade300,
              )
            ],
          ),
          child: Card(
            elevation: 20,
            color: Colors.grey.shade400,
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
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: widget.onEditPressed,
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                              onPressed: widget.onDeletePressed,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(widget.description,
                          textAlign: TextAlign.justify,
                          maxLines: 4,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade800, fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                widget.date,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              IconButton(
                                onPressed: () {
                                  String message = widget.description;
                                  String subject = widget.title;
                                  Share.share(message, subject: subject);
                                },
                                icon: Icon(
                                  Icons.share,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
