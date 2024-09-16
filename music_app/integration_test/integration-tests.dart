import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hive/hive.dart'; 
import 'package:music_app/domin/entities/artist.dart';
import 'package:music_app/main.dart' as app;
import 'package:music_app/presentation/pages/top_albums_page.dart';
import 'package:music_app/presentation/widgets/appbar_search_button.dart';
import 'package:music_app/presentation/pages/search_page.dart';
import 'package:music_app/presentation/blocs/artists/bloc/artists_bloc.dart';
import 'package:mockito/mockito.dart';
import '../test/mocks/mocks.mocks.dart'; 
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final mockArtistsBloc = MockArtistsBloc();
  
  setUp(() async {
    Hive.close();
    await Hive.initFlutter();

    final getIt = GetIt.instance;
    getIt.reset();

    getIt.registerSingleton<ArtistsBloc>(mockArtistsBloc);
    when(mockArtistsBloc.state).thenReturn(ArtistsInitial());
  });

  tearDown(() {
    GetIt.instance.reset();
    Hive.close();
  });

  group('Music App Integration Tests', () {
    testWidgets('Verify empty home screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('No Albums added yet'), findsOneWidget);
    });

    testWidgets('Search for "Coldplay" and navigate to top albums screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final searchButton = find.byType(AppbarSearchButton);
      expect(searchButton, findsOneWidget);
      await tester.tap(searchButton);
      await tester.pumpAndSettle();

      expect(find.byType(SearchPage), findsOneWidget);

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);
      await tester.enterText(searchField, 'Coldplay');

      final searchPageButton = find.byType(AppbarSearchButton);
      expect(searchPageButton, findsOneWidget);
      await tester.tap(searchPageButton);

      when(mockArtistsBloc.state).thenReturn(ArtistSearchSuccessState([
        TestArtist(name: 'Coldplay'),
        TestArtist(name: 'Coldplay, BTS'),
        TestArtist(name: 'COLDPLAY X BTS'),
        TestArtist(name: 'Coldplay & BTS'),
      ]));
      await tester.pumpAndSettle();

      final searchResultList = find.byType(GridView);
      final coldplayText = find.descendant(
        of: searchResultList,
        matching: find.text('Coldplay'),
      );

      await tester.tap(coldplayText);
      await tester.pumpAndSettle();

      expect(find.byType(TopAlbumPage), findsOneWidget);
    });
  });
}

class TestArtist extends Artist {
  TestArtist({String? name, String? listeners, String? mbid, String? url, String? streamable}) {
    this.name = name;
    this.listeners = listeners;
    this.mbid = mbid;
    this.url = url;
    this.streamable = streamable;
  }
}
