class TeamProbability {
  final String name;
  final double projectedPoints;
  final double top8Probability;
  final double top24Probability;
  final List<double> positionProbabilities;

  TeamProbability({
    required this.name,
    required this.projectedPoints,
    required this.top8Probability,
    required this.top24Probability,
    required this.positionProbabilities,
  });

  factory TeamProbability.fromJson(String name, Map<String, dynamic> json) {
    return TeamProbability(
      name: name,
      projectedPoints: (json['average_points'][name] as num).toDouble(),
      top8Probability:
          (json['qualification_probabilities_top8'][name] as num).toDouble(),
      top24Probability:
          (json['qualification_probabilities_top24'][name] as num).toDouble(),
      positionProbabilities:
          (json['position_probabilities'][name] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
    );
  }
}
