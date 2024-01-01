import 'package:fast_it_2/components/laporan/laporan.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() {
  setUpAll(() async {
    // Initialize Firebase before running any tests
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });
  testWidgets('Test Laporan Page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: Laporan(),
    ));

    // Test "Nama Sekolah" text presence
    expect(find.text("Nama Sekolah"), findsOneWidget);

    // Test interaction with TypeAheadFormField
    await tester.tap(find.byType(TypeAheadFormField));
    await tester.enterText(find.byType(TypeAheadFormField), 'SMK 1');
    await tester.pump();

    // Verify the entered value is displayed
    expect(find.text('SMK 1'), findsOneWidget);

    // Test interaction with TextFormField for "Ruangan"
    await tester.enterText(find.byType(TextFormField), 'Classroom A');
    await tester.pump();

    // Verify the entered value is displayed
    expect(find.text('Classroom A'), findsOneWidget);

    // Test interaction with DropdownButtonFormField for "Jenis Kerusakan"
    await tester.tap(find.byType(DropdownButtonFormField));
    await tester.pumpAndSettle();

    // Assuming the first item in the dropdown is selected
    await tester.tap(find.text('Kerusakan Ringan').last);
    await tester.pumpAndSettle();

    // Verify the selected value is displayed
    expect(find.text('Kerusakan Ringan'), findsOneWidget);

    // Test interaction with ElevatedButton for submission
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // You can continue writing tests for other widgets and interactions.

    // Check if the success dialog is displayed
    expect(find.text('Berhasil'), findsOneWidget);
  });
}
