import 'package:flutter/material.dart';

class CustomError extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomError({
    required this.errorDetails,
  });

  @override
  Widget build(BuildContext context) {
    print(errorDetails);
    return Center(
      child: Text(
        'Error occurred: ${errorDetails.exception}',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
