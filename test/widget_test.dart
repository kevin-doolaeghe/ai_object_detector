import 'package:flutter_test/flutter_test.dart';
import 'package:ai_object_detector/main.dart';

void main() {
  testWidgets('Application test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());
  });
}
