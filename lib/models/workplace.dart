import 'package:flutter/material.dart';

class Workplace {
  final String imagePath;
  final String title;
  final String location;
  final String hours;
  final double rating;
  final List<WorkplaceTag> tags;
  //final String description;
  final List<String> galleryImages;
  final double latitude;
  final double longitude;
  final int averagePrice;
  final double? distanceKm; 
  final List<WorkplaceReview>? reviews; 

  Workplace({
    required this.imagePath,
    required this.title,
    required this.location,
    required this.hours,
    required this.rating,
    required this.tags,
    //required this.description,
    required this.galleryImages,
    required this.latitude,
    required this.longitude,
    this.averagePrice = 0,
    this.distanceKm, 
    this.reviews, 
  });
}

enum WorkplaceTagCategory {
  workingConditions, 
  spaceFeatures,     
}

class WorkplaceTag {
  final IconData icon;
  final String label;
  final double value;
  final WorkplaceTagCategory category;

  WorkplaceTag({
    required this.icon,
    required this.label,
    required this.value,
    required this.category,
  });
}

class WorkplaceReview {
  final String userName;
  final String title;
  final String reviewText;
  final String imagePath;
  final DateTime reviewDate;
  final Map<String, int> ratings;

  WorkplaceReview({
    required this.userName,
    required this.title,
    required this.reviewText,
    required this.imagePath,
    required this.reviewDate,
    required this.ratings,
  });

 
  String _timeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays >= 1) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }
}
