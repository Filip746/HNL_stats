import 'package:flutter/material.dart';
import '../models/team_probability.dart';

class ProbabilityTable extends StatelessWidget {
  final List<TeamProbability> probabilities;

  const ProbabilityTable({Key? key, required this.probabilities})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Team')),
          DataColumn(label: Text('Proj. Points')),
          DataColumn(label: Text('Prvak (%)')),
          DataColumn(label: Text('Top 4 (%)')),
        ],
        rows: probabilities.map((team) {
          String imagePath =
              'images/${team.name.toLowerCase().replaceAll(" ", "_")}.png';
          return DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    Image.asset(imagePath,
                        width: 40, height: 40), // Prikaz slike
                    SizedBox(width: 8), // Razmak između slike i teksta
                    Text(team.name),
                  ],
                ),
              ),
              DataCell(Text(team.projectedPoints.toStringAsFixed(0))),
              DataCell(Text(team.top8Probability.toStringAsFixed(2))),
              DataCell(Text(team.top24Probability.toStringAsFixed(2))),
            ],
          );
        }).toList(),
      ),
    );
  }
}
