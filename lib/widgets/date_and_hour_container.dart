import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateAndHourContainer extends StatelessWidget {
  final DateTime date;
  final String hour;

  const DateAndHourContainer({
    super.key,
    required this.date,
    required this.hour,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 30,
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              Text(
                date.toString().split(' ').first,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
          Row(
            children: [
              Icon(Icons.access_time_outlined, size: 30, color: Colors.black),
              const SizedBox(width: 10),
              Text(
                '${hour.split(':').first}:${hour.split(':')[1]}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
