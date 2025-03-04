import '../models/team_probability.dart';

class ProbabilityData {
  static List<TeamProbability> getProbabilities() {
    return [
      TeamProbability(
        name: "Rijeka",
        projectedPoints: 68.0,
        top8Probability: 54.22,
        top24Probability: 99.99,
      ),
      TeamProbability(
        name: "Hajduk Split",
        projectedPoints: 67.0,
        top8Probability: 38.09,
        top24Probability: 99.99,
      ),
      TeamProbability(
        name: "D. Zagreb",
        projectedPoints: 63.0,
        top8Probability: 7.69,
        top24Probability: 99.60,
      ),
      TeamProbability(
        name: "Varazdin",
        projectedPoints: 48.0,
        top8Probability: 0.00,
        top24Probability: 38.97,
      ),
      TeamProbability(
        name: "Osijek",
        projectedPoints: 47.0,
        top8Probability: 0.00,
        top24Probability: 23.16,
      ),
      TeamProbability(
        name: "Slaven Belupo",
        projectedPoints: 46.0,
        top8Probability: 0.00,
        top24Probability: 20.19,
      ),
      TeamProbability(
        name: "Lok. Zagreb",
        projectedPoints: 45.0,
        top8Probability: 0.00,
        top24Probability: 12.86,
      ),
      TeamProbability(
        name: "Istra 1961",
        projectedPoints: 43.0,
        top8Probability: 0.00,
        top24Probability: 5.20,
      ),
      TeamProbability(
        name: "Gorica",
        projectedPoints: 35.0,
        top8Probability: 0.00,
        top24Probability: 0.04,
      ),
      TeamProbability(
        name: "Sibenik",
        projectedPoints: 26.0,
        top8Probability: 0.00,
        top24Probability: 0.00,
      ),
    ];
  }
}
