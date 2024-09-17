import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';
import '../../test/mocks/mocks.mocks.dart';
import 'package:music_app/presentation/blocs/artists/bloc/artists_bloc.dart';
import 'package:music_app/presentation/blocs/favorite_albums/bloc/favorite_albums_bloc.dart';
import 'package:music_app/presentation/widgets/appbar_search_button.dart';
import 'package:music_app/domin/entities/artist.dart';
import 'package:music_app/domin/entities/album.dart';

Future<void> initializeDependencies() async {
  Hive.close();
  await Hive.initFlutter();

  final getIt = GetIt.instance;
  getIt.reset(); 

  // Create mock instances of the blocs
  final mockArtistsBloc = MockArtistsBloc();
  final mockFavoriteAlbumsBloc = MockFavoriteAlbumsBloc();

  // Register the mock instances with GetIt
  getIt.registerSingleton<ArtistsBloc>(mockArtistsBloc);
  getIt.registerSingleton<FavoriteAlbumsBloc>(mockFavoriteAlbumsBloc);

  // Set initial states for the mocks
  when(mockArtistsBloc.state).thenReturn(ArtistsInitial());
  when(mockFavoriteAlbumsBloc.state).thenReturn(FavoriteAlbumsInitial());
}

// Resets dependencies and Hive state after each test
void resetDependencies() {
  GetIt.instance.reset();
  Hive.close();
}

// Navigates to the search page in the app
Future<void> navigateToSearchPage(WidgetTester tester) async {
  final searchButton = find.byType(AppbarSearchButton);
  expect(searchButton, findsOneWidget);
  await tester.tap(searchButton); 
  await tester.pumpAndSettle();
}

// Mocks the state of ArtistsBloc for the search
void mockArtistsBlocStateForSearch(List<TestArtist> artists) {
  final getIt = GetIt.instance;
  
  // Ensure ArtistsBloc is registered before attempting to mock its state
  if (getIt.isRegistered<ArtistsBloc>()) {
    final mockArtistsBloc = getIt<ArtistsBloc>();
    when(mockArtistsBloc.state).thenReturn(ArtistSearchSuccessState(artists));
  }
}

// Mocks the state of FavoriteAlbumsBloc for album interactions
void mockAlbumState(List<TestAlbum> albums) {
  final getIt = GetIt.instance;
  
  // Ensure FavoriteAlbumsBloc is registered before attempting to mock its state
  if (getIt.isRegistered<FavoriteAlbumsBloc>()) {
    final mockFavoriteAlbumsBloc = getIt<FavoriteAlbumsBloc>();
    when(mockFavoriteAlbumsBloc.state).thenReturn(FavoriteAlbumsSuccessState(albums));
  }
}

// Adds an album to favorites
Future<void> addAlbumToFavorites(WidgetTester tester, String albumName) async {
  final albumButton = find.byKey(ValueKey('${albumName}false'));
  expect(albumButton, findsOneWidget);
  await tester.tap(albumButton);
  await tester.pumpAndSettle();
}

// Mock Artist class for testing
class TestArtist extends Artist {
  TestArtist({
    String? name,
    String? listeners,
    String? mbid,
    String? url,
    String? streamable,
  }) {
    this.name = name;
    this.listeners = listeners;
    this.mbid = mbid;
    this.url = url;
    this.streamable = streamable;
  }
}

// Mock Album class for testing
class TestAlbum extends Album {
  @override
  String? name;
  @override
  int? playcount;
  @override
  String? mbid;
  @override
  String? url;
  @override
  Artist? artist;
  @override
  String? albumImage;
  @override
  bool? isFavorite;

  TestAlbum({
    this.name,
    this.playcount,
    this.mbid,
    this.url,
    this.artist,
    this.albumImage,
    this.isFavorite = false,
  });
}
