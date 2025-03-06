import 'package:flutter/material.dart';
import '../models/team_probability.dart';

class ProbabilityTable extends StatefulWidget {
  final List<TeamProbability> probabilities;

  const ProbabilityTable({Key? key, required this.probabilities})
      : super(key: key);

  @override
  _ProbabilityTableState createState() => _ProbabilityTableState();
}

class _ProbabilityTableState extends State<ProbabilityTable> {
  late List<TeamProbability> probabilities;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    probabilities = widget.probabilities;
  }

  void _sort<T>(Comparable<T> Function(TeamProbability d) getField,
      int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      probabilities.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.blue[100]),
          dataRowColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.grey[300];
            }
            return states.contains(WidgetState.hovered)
                ? Colors.grey[100]
                : null;
          }),
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          columns: [
            DataColumn(
              label: Text('Tim'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.name, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('Bodovi'),
              numeric: true,
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.projectedPoints, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('Prvak (%)'),
              numeric: true,
              onSort: (columnIndex, ascending) =>
                  _sort((d) => d.top8Probability, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('Top 4 (%)'),
              numeric: true,
              onSort: (columnIndex, ascending) =>
                  _sort((d) => d.top24Probability, columnIndex, ascending),
            ),
          ],
          rows: probabilities
              .map((team) => DataRow(
                    cells: [
                      DataCell(
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/${team.name.toLowerCase().replaceAll(" ", "_")}.png',
                              width: 30,
                              height: 30,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.sports_soccer),
                            ),
                            const SizedBox(width: 8),
                            Text(team.name),
                          ],
                        ),
                      ),
                      DataCell(Text(team.projectedPoints.toStringAsFixed(0))),
                      DataCell(
                          Text('${team.top8Probability.toStringAsFixed(2)}%')),
                      DataCell(
                          Text('${team.top24Probability.toStringAsFixed(2)}%')),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}
