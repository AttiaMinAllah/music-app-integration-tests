part of 'artists_bloc.dart';

abstract class ArtistsState extends Equatable {
  const ArtistsState();

  @override
  List<Object> get props => [];
}

class ArtistsInitial extends ArtistsState {}

class ArtistSearchLoadingState extends ArtistsState implements Loadable {}

class ArtistSearchFailedState extends ArtistsState implements Failable {
  ArtistSearchFailedState(this.failedResource);
  FailedResource failedResource;
  @override
  String getMessage() {
    return failedResource.message ?? '';
  }
}

class ArtistSearchSuccessState extends ArtistsState {
  ArtistSearchSuccessState(this.artists);
  List<Artist> artists;
}
