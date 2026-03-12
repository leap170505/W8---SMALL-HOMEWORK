import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final PlayerState playerState;
  AsyncValue<List<Song>> songs = const AsyncValue.loading();

  LibraryViewModel({required this.songRepository, required this.playerState}) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    // 1 - Fetch songs
    try {
      songs = const AsyncValue.loading();
      notifyListeners();
      final result = await songRepository.fetchSongs();
      songs = AsyncValue.data(result);
    } catch (e) {
      songs = AsyncValue.error(e);
    }
    // 2 - notify listeners
    notifyListeners();
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
  void retry() => _init();
}

class AsyncValue<T> {
  final T? data;
  final Object? error;
  final bool loading;

  const AsyncValue.loading() : data = null, error = null, loading = true;
  const AsyncValue.data(this.data) : error = null, loading = false;
  const AsyncValue.error(this.error) : data = null, loading = false;

  bool get hasError => error != null;
  bool get hasData => data != null;
}
