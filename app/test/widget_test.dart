import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/blocs/probability_bloc.dart';

void main() {
  testWidgets('Football Probability App smoke test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      BlocProvider(
        create: (context) => ProbabilityBloc(),
        child: const MyApp(),
      ),
    );

    // Verify that the initial loading state is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Trigger a frame to allow the BLoC to process the initial event
    await tester.pump();

    // Verify that the DataTable is displayed
    expect(find.byType(DataTable), findsOneWidget);

    // Verify that team names are displayed
    expect(find.text('Rijeka'), findsOneWidget);
    expect(find.text('Hajduk Split'), findsOneWidget);

    // Verify that probability columns are present
    expect(find.text('Proj. Points'), findsOneWidget);
    expect(find.text('Top 8 (%)'), findsOneWidget);
    expect(find.text('Top 24 (%)'), findsOneWidget);

    // Verify that some probability data is displayed
    expect(find.textContaining('%'), findsWidgets);
  });
}
