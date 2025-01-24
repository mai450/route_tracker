import 'package:flutter/material.dart';

class RouteDetails extends StatelessWidget {
  const RouteDetails({super.key, this.duration, this.distance});

  final String? duration;
  final String? distance;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 110,
      right: 20,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              "Duration:      $duration ",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              "Distance: $distance",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
