import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streak_up/main.dart';

void main() {
  testWidgets('Uygulama başlatma smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: StreakUpApp()),
    );

    // Uygulama başarıyla render edildi
    expect(find.byType(StreakUpApp), findsOneWidget);
  });
}
