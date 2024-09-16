import 'package:mockito/annotations.dart';
import 'package:music_app/presentation/blocs/albums/bloc/top_albums_bloc.dart';
import 'package:music_app/presentation/blocs/artists/bloc/artists_bloc.dart';
import 'package:music_app/presentation/blocs/favorite_albums/bloc/favorite_albums_bloc.dart';

@GenerateMocks([FavoriteAlbumsBloc, ArtistsBloc, TopAlbumsBloc])
void main() {}
