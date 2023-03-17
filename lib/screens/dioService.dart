// import 'package:dio/dio.dart';

// class DioService {
//   Future<dynamic> uploadPhotos(List<String> paths) async {
//     List<MultipartFile> files = [];
//     for (var path in paths) files.add(await MultipartFile.fromFile(path));

//     var formData = FormData.fromMap({'files': files});

//     var response =
//         await Dio().post('https://fakestoreapi.com/products', data: formData);
//     if (response.statusCode == 200) {
//       print('Image uploaded multiple');
//     } else {
//       print('Image upload fail dio');
//     }

//     print('\n\n');
//     print('RESPONSE WITH DIO');
//     print(response.data);
//     print('\n\n');
//     return response.data;
//   }
// }
