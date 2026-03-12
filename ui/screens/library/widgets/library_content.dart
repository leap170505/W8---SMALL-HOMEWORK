import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme.dart';
import '../../../widgets/song/song_tile.dart';
import '../view_model/library_view_model.dart';

class LibraryContent extends StatelessWidget {
  const LibraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    // 1- Read the globbal song repository
    LibraryViewModel mv = context.watch<LibraryViewModel>();
    if (mv.songs.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (mv.songs.hasError){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(mv.songs.error.toString(), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: mv.retry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text("Library", style: AppTextStyles.heading),
          SizedBox(height: 50),
          Expanded(
            child: ListView.builder(
              itemCount: mv.songs.data!.length,
              itemBuilder: (context, index) => SongTile(
                song: mv.songs.data![index],
                isPlaying: mv.isSongPlaying(mv.songs.data![index]),
                onTap: () {
                  mv.start(mv.songs.data![index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
