import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*class StarRating extends StatefulWidget {
  final int initialRating;
  final String serviceDocumentId; // Add the service document ID
  final void Function(int) onRatingChanged;

  StarRating({
    required this.initialRating,
    required this.serviceDocumentId,
    required this.onRatingChanged,
  });

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late int currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => IconButton(
          onPressed: () async {
            double newRating = index + 1.0;
            setState(() {
              currentRating = newRating;
            });

            // Update Firestore with the new rating
            await FirebaseFirestore.instance
                .collection('ServiceBook')
                .doc(widget.serviceDocumentId)
                .update({'starsrate': newRating});

            widget.onRatingChanged(newRating);
          },
          icon: Icon(
            index < currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}*/
// Import necessary packages and libraries

class StarRating extends StatefulWidget {
  final String serviceDocumentId;
  final void Function(int) onRatingChanged;
  final int initialRating; // Add this line with a default value

  StarRating({
    required this.serviceDocumentId,
    required this.onRatingChanged,
    this.initialRating = 0, // Add this line with a default value
  });

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late int currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = widget.initialRating; // Use initialRating here
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => IconButton(
          onPressed: () async {
            int newRating = index + 1;
            setState(() {
              currentRating = newRating;
            });

            try {
              // Update Firestore with the new rating
              await FirebaseFirestore.instance
                  .collection('ServiceBook')
                  .doc(widget.serviceDocumentId)
                  .update({'starsrate': newRating}).then((_) {
                print('Document ID: ${widget.serviceDocumentId}');
              }).catchError((error) {
                print('Error updating rating: $error');
              });

              widget.onRatingChanged(newRating);
            } catch (e) {
              // Handle Firestore update error
              print('Error updating rating: $e');
            }
          },
          icon: Icon(
            index < currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}