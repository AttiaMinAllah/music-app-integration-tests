
import 'package:injectable/injectable.dart';
import 'package:music_app/core/resource/resource.dart';
import 'package:music_app/core/usecase/usecase.dart';
import 'package:music_app/domin/repositories/albums_repository.dart';

@LazySingleton()
class GetFavoriteAlbums extends NonParametersUseCase<Resource> {
  final AlbumsRepository albumsRepository;

  GetFavoriteAlbums(this.albumsRepository);

  @override
  Future<Resource> call() async {
    return await albumsRepository.getFavoritesAlbums();
  }
}
