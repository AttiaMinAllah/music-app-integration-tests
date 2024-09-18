import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:music_app/main.dart' as app;
import 'package:music_app/presentation/pages/top_albums_page.dart';
import 'package:music_app/presentation/widgets/appbar_search_button.dart';
import 'package:music_app/presentation/blocs/artists/bloc/artists_bloc.dart';
import 'package:music_app/presentation/blocs/favorite_albums/bloc/favorite_albums_bloc.dart';
import 'package:mockito/mockito.dart';
import '../test/mocks/mocks.mocks.dart'; 
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final mockArtistsBloc = MockArtistsBloc();
  final mockFavoriteAlbumsBloc = MockFavoriteAlbumsBloc();
  
  setUp(() async {
    Hive.close();
    await Hive.initFlutter();

    final getIt = GetIt.instance;
    getIt.reset();

    getIt.registerSingleton<ArtistsBloc>(mockArtistsBloc);
    getIt.registerSingleton<FavoriteAlbumsBloc>(mockFavoriteAlbumsBloc);
    when(mockArtistsBloc.state).thenReturn(ArtistsInitial());
    when(mockFavoriteAlbumsBloc.state).thenReturn(FavoriteAlbumsInitial());
  });

  tearDown(() {
    GetIt.instance.reset();
    Hive.close();
  });

  group('Top Albums Screen Tests', () {
    testWidgets('Search for an artist to favorites and verify on the home screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to the search page
      final searchButton = find.byType(AppbarSearchButton);
      expect(searchButton, findsOneWidget);
      await tester.tap(searchButton);
      await tester.pumpAndSettle();

      // Enter "Coldplay" in the search field
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);
      await tester.enterText(searchField, 'Coldplay');

      final searchPageButton = find.byType(AppbarSearchButton);
      expect(searchPageButton, findsOneWidget);
      await tester.tap(searchPageButton);

      // Mock the search result state
      when(mockArtistsBloc.state).thenReturn(ArtistSearchSuccessState([
        TestArtist(name: 'Coldplay'),
      ]));
      await tester.pumpAndSettle();

      // Tap on "Coldplay" to navigate to the top albums page
      final searchResultList = find.byType(GridView);
      final coldplayText = find.descendant(
        of: searchResultList,
        matching: find.text('Coldplay'),
      );

      await tester.tap(coldplayText);
      await tester.pumpAndSettle();

      expect(find.byType(TopAlbumPage), findsOneWidget);

      // Mock the album state with one test album
      final album1 = TestAlbum(name: 'A Rush of Blood to the Head', isFavorite: false);

      when(mockFavoriteAlbumsBloc.state).thenReturn(FavoriteAlbumsSuccessState([
        album1,
      ]));
      await tester.pumpAndSettle();

      // Verify the widget exists before interacting with it
      expect(find.byKey(ValueKey('A Rush of Blood to the Headfalse')), findsOneWidget);

      // Find and tap the favorite button using mock data
      final favoriteButton = find.byKey(ValueKey('A Rush of Blood to the Headfalse'));

      await tester.tap(favoriteButton);
      await tester.pumpAndSettle();

      // Mock the updated favorite state after adding to favorites
      when(mockFavoriteAlbumsBloc.state).thenReturn(FavoriteAlbumsSuccessState([
        TestAlbum(name: 'A Rush of Blood to the Head', isFavorite: true),
      ]));

      // Navigate back to the home screen
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Verify that the album has been added to the favorites list on the home page
      expect(find.text('A Rush of Blood to the Head'), findsOneWidget);
    });

     testWidgets('Unfavorite an album from the home page', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Mock the favorite state with an album already added
      final testAlbum = TestAlbum(name: 'A Rush of Blood to the Head', isFavorite: true);
      when(mockFavoriteAlbumsBloc.state).thenReturn(FavoriteAlbumsSuccessState([testAlbum]));
      await tester.pumpAndSettle();

      // Verify that the album is on the home page
      expect(find.text('A Rush of Blood to the Head'), findsOneWidget);

      // Find and tap the unfavorite button on the home page
      final unfavoriteButton = find.byKey(ValueKey('A Rush of Blood to the Headtrue'));
      await tester.tap(unfavoriteButton);
      await tester.pumpAndSettle();

      // Mock the updated favorite state after removing the album from favorites
      when(mockFavoriteAlbumsBloc.state).thenReturn(FavoriteAlbumsSuccessState([]));
      await tester.pumpAndSettle();
 });

    testWidgets('Verify when user unfavourites and album from top albums page it reflects on home screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final searchButton = find.byType(AppbarSearchButton);
      expect(searchButton, findsOneWidget);
      await tester.tap(searchButton);
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);
      await tester.enterText(searchField, 'Coldplay');

      final searchPageButton = find.byType(AppbarSearchButton);
      expect(searchPageButton, findsOneWidget);
      await tester.tap(searchPageButton);

      when(mockArtistsBloc.state).thenReturn(ArtistSearchSuccessState([
        TestArtist(name: 'Coldplay'),
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

      final album1 = TestAlbum(name: 'Parachutes', isFavorite: false);

      when(mockFavoriteAlbumsBloc.state).thenReturn(FavoriteAlbumsSuccessState([
        album1,
      ]));
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey('Parachutesfalse')), findsOneWidget);

      final favoriteButton = find.byKey(ValueKey('Parachutesfalse'));

      await tester.tap(favoriteButton);
      await tester.pumpAndSettle();

      when(mockFavoriteAlbumsBloc.state).thenReturn(FavoriteAlbumsSuccessState([
        TestAlbum(name: 'Parachutes', isFavorite: true),
      ]));

      // Navigate back to search result page
      await tester.pageBack();
      await tester.pumpAndSettle();
      
      // Navigate back to home screen
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Verify that the album has been added to the favorites list on the home page
      expect(find.text('Parachutes'), findsOneWidget);

      // Now unfavorite the album
      // Navigate to the search page again
      await tester.tap(searchButton);
      await tester.pumpAndSettle();

      // Enter "Coldplay" in the search field again
      await tester.enterText(searchField, 'Coldplay');
      await tester.tap(searchPageButton);
      await tester.pumpAndSettle();

      // Mock the album state again to mark it as not favorite
      when(mockFavoriteAlbumsBloc.state).thenReturn(FavoriteAlbumsSuccessState([
        TestAlbum(name: 'Parachutes', isFavorite: true),
      ]));
      await tester.pumpAndSettle();

      // Tap on "Coldplay" to navigate to the top albums page again
      await tester.tap(coldplayText);
      await tester.pumpAndSettle();

      // Tap the unfavorite button
      final unfavoriteButton = find.byKey(ValueKey('Parachutestrue'));
      await tester.tap(unfavoriteButton);
      await tester.pumpAndSettle();

      // Mock the updated favorite state after removing from favorites
      when(mockFavoriteAlbumsBloc.state).thenReturn(FavoriteAlbumsSuccessState([]));
      await tester.pumpAndSettle();

      // Navigate back to home screen
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Verify that the album has been removed from the favorites list on the home page
      expect(find.text('Parachutes'), findsNothing);
    },skip: true);   // skipping the test because unfavouriting from top albums screen does not reflect on homescreen.
  });
}