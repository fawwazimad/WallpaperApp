import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:starterapp/pages/home/search_screen.dart';
import 'package:starterapp/pages/home/wallpaper_details_screen.dart';

import 'favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List photos = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String apiKey = 'ihgPyTiXzuZGXZdKMxGes9xuMGlf4cPFyJsiCPGOe0Vre2Q2wvn9OSC3';
    Map<String, String> headers = {
      'Authorization': apiKey,
    };
    Random rand = Random();
    int randNum = rand.nextInt(100);
    await http
        .get(Uri.parse('https://api.pexels.com/v1/curated?page=$randNum'),
            headers: headers)
        .then((value) {
      final Map<String, dynamic> data = jsonDecode(value.body);
      setState(() {
        photos = data['photos'];
      });
    });
  }

  get favoriteWallpaperUrls => ['null'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Random Wallpapers"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        itemCount: photos.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WallpaperDetailsScreen(
                      imageUrl: photos[index]['src']['large2x'],
                      imageId: photos[index]['id'],
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: photos[index]['src']['tiny'],
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ));
        },
        staggeredTileBuilder: (int index) =>
            StaggeredTile.count(1, index.isEven ? 1.2 : 1.5),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
    );
  }
}
