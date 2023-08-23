import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:starterapp/common_widgets/custom_raised_button.dart';

import '../../database/database_helper.dart';

class WallpaperDetailsScreen extends StatelessWidget {
  final String imageUrl; // URL of the selected wallpaper
  final dynamic imageId;

  const WallpaperDetailsScreen({
    super.key,
    required this.imageUrl,
    required this.imageId,
  });

  @override
  Widget build(BuildContext context) {
    Random rand = Random();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpaper Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomRaisedButton(
                  onPressed: () async {
                    int randomNum = rand.nextInt(100000);
                    http.Response response =
                        await http.get(Uri.parse(imageUrl));

                    List<int> imageData = response.bodyBytes;

                    Directory? directory = await getExternalStorageDirectory();

                    File file = File(
                        '${directory?.path}/downloaded_image$randomNum.jpg');
                    await file.writeAsBytes(imageData);

                    Fluttertoast.showToast(
                      msg: 'Saved to ${file.path}',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                  },
                  child: const Text('Download'),
                ),
                CustomRaisedButton(
                    child: const Text('Add to Favorites'),
                    onPressed: () async {
                      Map<String, dynamic> favoriteData = {
                        'imageUrl': imageUrl,
                        'id': imageId,
                      };
                      int result = await DatabaseHelper.instance
                          .insertFavorite(favoriteData);

                      if (result > 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to favorites!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
