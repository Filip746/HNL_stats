import 'package:app/models/team_probability.dart';
import 'package:app/widgets/probability_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProbabilityTable Widget Tests', () {
    final mockProbabilities = [
      TeamProbability(
        name: 'Team A',
        projectedPoints: 50,
        top8Probability: 30,
        top24Probability: 60,
        positionProbabilities: List.generate(10, (index) => 10.0),
      ),
      TeamProbability(
        name: 'Team B',
        projectedPoints: 60,
        top8Probability: 40,
        top24Probability: 70,
        positionProbabilities: List.generate(10, (index) => 9.0),
      ),
    ];

    testWidgets('ProbabilityTable renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home:
            Scaffold(body: ProbabilityTable(probabilities: mockProbabilities)),
      ));

      expect(find.byType(DataTable), findsNWidgets(2));
      expect(find.text('Tim'), findsNWidgets(2));
      expect(find.text('Bodovi'), findsOneWidget);
      expect(find.text('Prvak (%)'), findsOneWidget);
      expect(find.text('Top 4 (%)'), findsOneWidget);
      expect(find.text('Vjerojatnosti pozicija za svaki klub (%)'),
          findsOneWidget);
    });

    testWidgets('ProbabilityTable displays team data correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home:
            Scaffold(body: ProbabilityTable(probabilities: mockProbabilities)),
      ));

      expect(find.text('Team A'), findsNWidgets(2));
      expect(find.text('50'), findsOneWidget);
      expect(find.text('30.00%'), findsOneWidget);
      expect(find.text('60.00%'), findsOneWidget);
    });

    testWidgets('ProbabilityTable sorting works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home:
            Scaffold(body: ProbabilityTable(probabilities: mockProbabilities)),
      ));

      await tester.tap(find.text('Bodovi'));
      await tester.pumpAndSettle();

      final firstTeamName =
          find.byType(DataTable).first.evaluate().first.widget as DataTable;
      expect(firstTeamName.rows.first.cells.first.child, isA<Row>());
      expect((firstTeamName.rows.first.cells.first.child as Row).children.last,
          isA<Text>());
      expect(
          ((firstTeamName.rows.first.cells.first.child as Row).children.last
                  as Text)
              .data,
          'Team B');
    });

    testWidgets('ProbabilityTable displays team logos',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home:
            Scaffold(body: ProbabilityTable(probabilities: mockProbabilities)),
      ));

      expect(find.byType(Image), findsNWidgets(mockProbabilities.length * 2));
    });
  });
}
