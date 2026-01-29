import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ImageCacheService {
  static const List<String> _imageUrls = [
    'https://wiki.warframe.com/images/LithRelicIntact.png?ee7d7',
    'https://wiki.warframe.com/images/MesoRelicIntact.png?a9b4a',
    'https://wiki.warframe.com/images/NeoRelicIntact.png?6dc86',
    'https://wiki.warframe.com/images/AxiRelicIntact.png?6cadf',
    'https://wiki.warframe.com/images/RequiemRelicIntact.png?03821',
  ];

  static final Map<String, String> _urlToLocalPath = {};
  static final Map<String, String> _typeToLocalPath = {
    'lith': '',
    'meso': '',
    'neo': '',
    'axi': '',
    'requiem': '',
  };

  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    final directory = await getApplicationCacheDirectory();
    final cacheDir = Directory('${directory.path}/relic_images');

    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    // Start caching in parallel
    Future<void> cacheInitTask() async {
      for (int i = 0; i < _imageUrls.length; i++) {
        final url = _imageUrls[i];
        final fileName = 'relic_$i.png';
        final filePath = '${cacheDir.path}/$fileName';
        final file = File(filePath);

        if (!await file.exists()) {
          try {
            final response = await http.get(Uri.parse(url));
            if (response.statusCode == 200) {
              await file.writeAsBytes(response.bodyBytes);
            }
          } catch (_) {}
        }

        _urlToLocalPath[url] = filePath;
      }

      _typeToLocalPath['lith'] = _urlToLocalPath[_imageUrls[0]] ?? '';
      _typeToLocalPath['meso'] = _urlToLocalPath[_imageUrls[1]] ?? '';
      _typeToLocalPath['neo'] = _urlToLocalPath[_imageUrls[2]] ?? '';
      _typeToLocalPath['axi'] = _urlToLocalPath[_imageUrls[3]] ?? '';
      _typeToLocalPath['requiem'] = _urlToLocalPath[_imageUrls[4]] ?? '';

      _isInitialized = true;
    }

    // We don't await this task here to allow main() to continue
    cacheInitTask();
  }

  static String? getLocalImagePath(String imageUrl) {
    if (imageUrl.isEmpty) return null;
    return _urlToLocalPath[imageUrl];
  }

  static String? getLocalImagePathByType(String type) {
    final normalizedType = type.toLowerCase();
    return _typeToLocalPath[normalizedType];
  }
}
