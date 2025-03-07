import 'package:flutter/material.dart';
import '../models/team_probability.dart';

class ProbabilityTable extends StatefulWidget {
  final List<TeamProbability> probabilities;

  const ProbabilityTable({super.key, required this.probabilities});

  @override
  // ignore: library_private_types_in_public_api
  _ProbabilityTableState createState() => _ProbabilityTableState();
}

class _ProbabilityTableState extends State<ProbabilityTable> {
  late List<TeamProbability> upperTableProbabilities;
  late List<TeamProbability> lowerTableProbabilities;
  int _upperSortColumnIndex = 0;
  bool _upperSortAscending = true;
  int _lowerSortColumnIndex = 0;
  bool _lowerSortAscending = true;

  @override
  void initState() {
    super.initState();
    upperTableProbabilities = List.from(widget.probabilities);
    lowerTableProbabilities = List.from(widget.probabilities);
  }

  void _sortUpperTable<T>(Comparable<T> Function(TeamProbability d) getField,
      int columnIndex, bool ascending) {
    setState(() {
      _upperSortColumnIndex = columnIndex;
      _upperSortAscending = ascending;
      upperTableProbabilities.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  void _sortLowerTable<T>(Comparable<T> Function(TeamProbability d) getField,
      int columnIndex, bool ascending) {
    setState(() {
      _lowerSortColumnIndex = columnIndex;
      _lowerSortAscending = ascending;
      lowerTableProbabilities.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  Widget _buildDataTable({
    required List<DataColumn> columns,
    required List<DataRow> rows,
    required int sortColumnIndex,
    required bool sortAscending,
  }) {
    return DataTable(
      headingRowColor: WidgetStateProperty.all(Colors.blue[100]),
      dataRowColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.grey[300];
        return states.contains(WidgetState.hovered) ? Colors.grey[100] : null;
      }),
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      columns: columns,
      rows: rows,
    );
  }

  DataCell _buildTeamCell(String teamName) {
    return DataCell(
      Row(
        children: [
          Image.asset(
            'images/${teamName.toLowerCase().replaceAll(" ", "_")}.png',
            width: 30,
            height: 30,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.sports_soccer),
          ),
          const SizedBox(width: 8),
          Text(teamName),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildDataTable(
              columns: [
                DataColumn(
                  label: const Text('Tim',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onSort: (columnIndex, ascending) =>
                      _sortUpperTable((d) => d.name, columnIndex, ascending),
                ),
                DataColumn(
                  label: const Text('Bodovi',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  numeric: true,
                  onSort: (columnIndex, ascending) => _sortUpperTable(
                      (d) => d.projectedPoints, columnIndex, ascending),
                ),
                DataColumn(
                  label: const Text('Prvak (%)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  numeric: true,
                  onSort: (columnIndex, ascending) => _sortUpperTable(
                      (d) => d.top8Probability, columnIndex, ascending),
                ),
                DataColumn(
                  label: const Text('Top 4 (%)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  numeric: true,
                  onSort: (columnIndex, ascending) => _sortUpperTable(
                      (d) => d.top24Probability, columnIndex, ascending),
                ),
              ],
              rows: upperTableProbabilities
                  .map((team) => DataRow(
                        cells: [
                          _buildTeamCell(team.name),
                          DataCell(
                              Text(team.projectedPoints.toStringAsFixed(0))),
                          DataCell(Text(
                              '${team.top8Probability.toStringAsFixed(2)}%')),
                          DataCell(Text(
                              '${team.top24Probability.toStringAsFixed(2)}%')),
                        ],
                      ))
                  .toList(),
              sortColumnIndex: _upperSortColumnIndex,
              sortAscending: _upperSortAscending,
            ),
          ),
          const SizedBox(height: 20),
          const Text("Vjerojatnosti pozicija za svaki klub (%)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildDataTable(
              columns: [
                DataColumn(
                  label: const Text('Tim',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onSort: (columnIndex, ascending) =>
                      _sortLowerTable((d) => d.name, columnIndex, ascending),
                ),
                for (int i = 1; i <= 10; i++)
                  DataColumn(
                    label: Text(i.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    numeric: true,
                    onSort: (columnIndex, ascending) => _sortLowerTable(
                        (d) => d.positionProbabilities[columnIndex - 1],
                        columnIndex,
                        ascending),
                  ),
              ],
              rows: lowerTableProbabilities
                  .map((team) => DataRow(
                        cells: [
                          _buildTeamCell(team.name),
                          for (int i = 0; i < 10; i++)
                            DataCell(Text(
                                '${team.positionProbabilities[i].toStringAsFixed(2)}%')),
                        ],
                      ))
                  .toList(),
              sortColumnIndex: _lowerSortColumnIndex,
              sortAscending: _lowerSortAscending,
            ),
          ),
        ],
      ),
    );
  }
}
