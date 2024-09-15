import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:music_app/main.dart' as app;
import 'package:music_app/presentation/pages/home_page.dart';
import 'package:music_app/presentation/widgets/appbar_search_button.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Empty Home Screen Test', () {
    testWidgets('Home screen text assertion', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      // Assertion to verify no album exists already
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text('No Albums added yet'), findsOneWidget);
      // Assert Search button
      expect(find.byType(AppbarSearchButton), findsOneWidget);
      
    });
  });
}


