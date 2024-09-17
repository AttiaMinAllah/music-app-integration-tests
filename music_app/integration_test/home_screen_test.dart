import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:music_app/main.dart' as app;
import 'utils/test_utils.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDependencies();
  });

  tearDown(() {
    resetDependencies();
  });

  group('Home Screen Tests', () {
    testWidgets('Verify empty home screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      expect(find.text('No Albums added yet'), findsOneWidget);
    });
  });
}
