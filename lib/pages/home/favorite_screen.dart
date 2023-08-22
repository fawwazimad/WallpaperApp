import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:starterapp/pages/home/wallpaper_details_screen.dart';

import '../../common_widgets/custom_raised_button.dart';
import '../../database/database_helper.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    List photos = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Wallpapers'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getFavorites(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final favorites = snapshot.data!;

          if (favorites.isEmpty) {
            return const Center(
              child: Text('No favorite wallpapers yet.'),
            );
          }

          return StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final imageUrl = favorites[index]['imageUrl'];
              final imageId = favorites[index]['id'];
              print(imageId);
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WallpaperDetailsScreen(
                          imageUrl: favorites[index]['imageUrl'],
                          imageId: favorites[index]['ID'],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        height: 150,
                        imageUrl: imageUrl,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                      CustomRaisedButton(
                          child: const Text('Delete'),
                          onPressed: () async {
                            dbHelper.deleteFavorite(imageId);
                            setState(() {});
                          }),
                    ],
                  ));
            },
            staggeredTileBuilder: (int index) =>
                StaggeredTile.count(1, index.isEven ? 1.2 : 1.5),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          );
        },
      ),
    );
  }
}
