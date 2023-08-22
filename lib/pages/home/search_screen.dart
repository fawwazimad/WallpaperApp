import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:starterapp/pages/home/wallpaper_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List photos = [];
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
    fetchData('');
  }

  Future<void> fetchData(String query) async {
    String apiKey = 'ihgPyTiXzuZGXZdKMxGes9xuMGlf4cPFyJsiCPGOe0Vre2Q2wvn9OSC3';
    Map<String, String> headers = {
      'Authorization': apiKey,
    };

    await http
        .get(
            Uri.parse(
                'https://api.pexels.com/v1/search?query=$query&per_page=1'),
            headers: headers)
        .then((value) {
      final Map<String, dynamic> data = jsonDecode(value.body);
      setState(() {
        photos = data['photos'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Wallpapers'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                fetchData(value);
              },
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Enter a search query',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
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
                  child: Image.network(
                    photos[index]['src']['tiny'],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
