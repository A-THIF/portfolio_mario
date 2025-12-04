import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// ProjectItem model
class ProjectItem {
  final String title;
  final String shortDescription;
  final String fullDescription;
  final String? githubLink;
  final String? linkedinLink;
  final int year;
  final String type;
  final List<String> tags;
  final List<String> skillsChips;

  ProjectItem({
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    this.githubLink,
    this.linkedinLink,
    required this.year,
    required this.type,
    required this.tags,
    required this.skillsChips,
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      title: json['title'],
      shortDescription: json['shortDescription'],
      fullDescription: json['fullDescription'],
      githubLink: json['githubLink'],
      linkedinLink: json['linkedinLink'],
      year: json['year'],
      type: json['type'],
      tags: List<String>.from(json['tags']),
      skillsChips: List<String>.from(json['skillsChips']),
    );
  }
}

// PortfolioData class with all constants
class AppConfig {
  // --- Bio ---
  static const String name = "MOHAMED ATHIF N";
  static const String tagline = "INSPIRE & INFLUENCE";
  static const String profileImage = "assets/images/profile.png";

  static const String aboutMe = """
Hi, I'm Mohamed Athif N—a passionate builder who loves turning ideas into reality.
...
""";

  // --- Social Links ---
  static const String linkedin = "https://www.linkedin.com/in/n-mohamed-athif";
  static const String github = "https://github.com/A-THIF";
  static const String email = "mailto:athif.n.official@gmail.com";

  // --- Skills ---
  static const List<String> skills = [
    "Flutter",
    "Dart",
    "Python",
    "Firebase",
    "Arduino",
  ];

  // --- Load Projects from JSON ---
  static Future<List<ProjectItem>> loadProjects() async {
    final jsonString = await rootBundle.loadString(
      'lib/config/projects_data.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    // Sort Flutter projects first, then by year descending
    jsonData.sort((a, b) {
      if (a['type'] == 'flutter' && b['type'] != 'flutter') return -1;
      if (b['type'] == 'flutter' && a['type'] != 'flutter') return 1;
      return b['year'].compareTo(a['year']);
    });
    return jsonData.map((e) => ProjectItem.fromJson(e)).toList();
  }
}
