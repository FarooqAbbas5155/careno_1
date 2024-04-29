import 'package:flutter/material.dart';

class FullImageView extends StatelessWidget {
  String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network(
          imageUrl, // Path to your full image
          fit: BoxFit.contain, // Adjust as per your requirement
        ),
      ),
    );
  }

  FullImageView({
    required this.imageUrl,
  });
}
