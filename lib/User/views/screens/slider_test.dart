import 'package:flutter/material.dart';

class TimePickerSliderDemo extends StatefulWidget {
  @override
  _TimePickerSliderDemoState createState() => _TimePickerSliderDemoState();
}

class _TimePickerSliderDemoState extends State<TimePickerSliderDemo> {
  double startTime = 1; // Initial pick time
  double endTime = 24; // Initial drop time
  double hoursDifference = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Picker Slider'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pick Time: ${startTime.toStringAsFixed(0)}',
              textAlign: TextAlign.center,
            ),
            Slider(
              min: 1,
              max: 24,
              divisions: 23,
              value: startTime,
              onChanged: (value) {
                setState(() {
                  startTime = value;
                  calculateHoursDifference();
                });
              },
            ),
            Text(
              'Drop Time: ${endTime.toStringAsFixed(0)}',
              textAlign: TextAlign.center,
            ),
            Slider(
              min: 1,
              max: 24,
              divisions: 23,
              value: endTime,
              onChanged: (value) {
                setState(() {
                  endTime = value;
                  calculateHoursDifference();
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Hours Difference: $hoursDifference',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void calculateHoursDifference() {
    hoursDifference = endTime - startTime;
    if (hoursDifference < 0) {
      hoursDifference += 24; // Adjust for cases where drop time is before pick time
    }
    setState(() {
      hoursDifference = hoursDifference;
    });
  }
}
