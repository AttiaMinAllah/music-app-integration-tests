import 'package:equatable/equatable.dart';
import 'package:music_app/domin/entities/artist.dart';
import 'package:music_app/domin/entities/track.dart';

abstract class Album extends Equatable {
  String? name;
  int? playcount;
  String? mbid;
  String? url;
  Artist? artist;
  String? albumImage;
  bool? isFavorite;
  List<Track>? tracks;

  @override
  List<Object?> get props => [mbid];

  @override
  bool? get stringify => true;
}
