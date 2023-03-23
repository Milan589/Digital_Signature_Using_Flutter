import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService {
  Future<String> uploadPhotos(List<String> paths) async {
    Uri uri = Uri.parse('https://fakestoreapi.com/products');
    print(uri);
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    for (String path in paths) {
      request.files.add(await http.MultipartFile.fromPath('files', path));
    }

    http.StreamedResponse response = await request.send();

    var responseBytes = await response.stream.toBytes();
    var responseString = utf8.decode(responseBytes);
    if (response.statusCode == 200) {
      print('Image uploaded success');
    } else {
      print('Image upload fail http');
    }
    print('\n\n');
    print('RESPONSE WITH HTTP');
    print(responseString);
    print('\n\n');
    return responseString;
  }
}
