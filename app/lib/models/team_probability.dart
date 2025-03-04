class TeamProbability {
  final String name;
  final double projectedPoints;
  final double top8Probability;
  final double top24Probability;

  TeamProbability({
    required this.name,
    required this.projectedPoints,
    required this.top8Probability,
    required this.top24Probability,
  });

  factory TeamProbability.fromJson(Map<String, dynamic> json) {
    return TeamProbability(
      name: json['name'],
      projectedPoints: json['projected_points'],
      top8Probability: json['top8_probability'].toDouble(),
      top24Probability: json['top24_probability'].toDouble(),
    );
  }
}
