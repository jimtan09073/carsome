import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/image.model.dart';

class ImageService with ChangeNotifier {
  static final String baseUrl = 'https://jsonplaceholder.typicode.com/photos';
  static final BaseOptions baseOptions = new BaseOptions(connectTimeout: 5000);
  List<ImageModel> _imageList = [];

  List<ImageModel> get imageList {
    return _imageList;
  }

  void populateList(List<dynamic> list) {
    List<ImageModel> data =
        list.map((image) => ImageModel.fromJson(image)).toList();
    _imageList.addAll(data);
    notifyListeners();
  }

  void clearList() {
    _imageList.clear();
    notifyListeners();
  }

  Future<Response> fetchDataFromAlbum(String id) async {
    try {
      Response resp = await Dio().get(
        '$baseUrl',
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
        queryParameters: {'albumId': id},
      );
      return Future.value(resp);
    } on DioError catch (err) {
      return Future.error(err);
    }
  }
}
