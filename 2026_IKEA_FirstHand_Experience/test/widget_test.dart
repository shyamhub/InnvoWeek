import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_home_demo/main.dart';

void main() {
  testWidgets('welcomes users and opens the virtual living room', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VirtualHomeApp());

    expect(find.text('A smarter home\nstarts with a feeling.'), findsOneWidget);
    expect(find.text('Explore IKEA Home smart'), findsOneWidget);

    final welcomeButton = find.text('Explore IKEA Home smart');
    await tester.ensureVisible(welcomeButton);
    await tester.pumpAndSettle();
    await tester.tap(welcomeButton);
    await tester.pumpAndSettle();

    expect(find.text('Your home,'), findsOneWidget);
    expect(find.text('your kind of everyday.'), findsOneWidget);
    expect(find.text('Bedroom'), findsOneWidget);

    final livingRoom = find.text('Living room').first;
    await tester.ensureVisible(livingRoom);
    await tester.pumpAndSettle();
    await tester.tap(livingRoom);
    await tester.pumpAndSettle();

    expect(find.text('A different feeling'), findsOneWidget);
    expect(find.text('Movie night'), findsOneWidget);
    expect(find.text('Good night'), findsOneWidget);

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -550));
    await tester.pumpAndSettle();
    final lightCard = find.byKey(const ValueKey('light-card-ceiling-light'));
    final lightCardHeight = tester.getSize(lightCard).height;
    await tester.tap(find.byKey(const ValueKey('light-switch-ceiling-light')));
    await tester.pump(const Duration(milliseconds: 100));
    expect(lightCard, findsOneWidget);
    expect(tester.getSize(lightCard).height, lightCardHeight);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ceiling light').first);
    await tester.pumpAndSettle();
    expect(find.text('Light colour'), findsOneWidget);
    expect(find.text('Colour temperature · 2700 K'), findsOneWidget);
    await tester.tap(find.byTooltip('Lilac'));
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.text('Light colour'))).pop();
    await tester.pumpAndSettle();

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -1600));
    await tester.pumpAndSettle();
    expect(find.text('Set up your real home'), findsOneWidget);
    await tester.tap(find.text('Set up your real home'));
    await tester.pump();
    expect(
      find.text('Your smart home journey starts whenever you are.'),
      findsOneWidget,
    );
  });
}
