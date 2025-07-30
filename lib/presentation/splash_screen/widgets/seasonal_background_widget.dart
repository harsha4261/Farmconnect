import 'package:flutter/material.dart';

class SeasonalBackgroundWidget extends StatelessWidget {
  const SeasonalBackgroundWidget({Key? key}) : super(key: key);

  String _getCurrentSeasonImage() {
    final now = DateTime.now();
    final month = now.month;

    // Determine season based on month
    if (month >= 3 && month <= 5) {
      // Spring
      return 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80';
    } else if (month >= 6 && month <= 8) {
      // Summer
      return 'https://images.pexels.com/photos/440731/pexels-photo-440731.jpeg?auto=compress&cs=tinysrgb&w=1000';
    } else if (month >= 9 && month <= 11) {
      // Autumn
      return 'https://images.pixabay.com/photo-2016/09/10/11/11/wheat-field-1659703_1280.jpg';
    } else {
      // Winter
      return 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_getCurrentSeasonImage()),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withAlpha(77),
              Colors.black.withAlpha(153),
            ],
          ),
        ),
      ),
    );
  }
}
