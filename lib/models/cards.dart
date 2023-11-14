import 'package:get/get.dart';
import 'package:flutter/material.dart';

class GlassyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor, // Use theme for card color
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // Add your card content here
            Image.network(
              'https://example.com/your-image.jpg', // Replace with your image URL
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            // Add glass effect overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // You can add other card contents, such as title and subtitle, on top of the image
            // Example:
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Text(
                'Card Title',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
