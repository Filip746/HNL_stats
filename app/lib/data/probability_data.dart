import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/team_probability.dart';

class ProbabilityData {
  static Future<List<TeamProbability>> getProbabilities() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/probabilities'));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<TeamProbability> probabilities = [];
      jsonData['average_points'].forEach((key, value) {
        probabilities.add(TeamProbability.fromJson(key, jsonData));
      });
      return probabilities;
    } else {
      throw Exception('Failed to load probabilities: ${response.statusCode}');
    }
  }
}
