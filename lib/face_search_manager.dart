import 'package:dio/dio.dart';
import 'package:photos/core/configuration.dart';
import 'package:photos/db/photo_db.dart';
import 'package:logging/logging.dart';

import 'package:photos/models/face.dart';
import 'package:photos/models/photo.dart';

class FaceSearchManager {
  final logger = Logger("FaceSearchManager");
  final _dio = Dio();

  FaceSearchManager._privateConstructor();
  static final FaceSearchManager instance =
      FaceSearchManager._privateConstructor();

  Future<List<Face>> getFaces() {
    return _dio
        .get(
          Configuration.instance.getHttpEndpoint() + "/photos/faces",
          options: Options(
              headers: {"X-Auth-Token": Configuration.instance.getToken()}),
        )
        .then((response) => (response.data["faces"] as List)
            .map((face) => new Face.fromJson(face))
            .toList())
        .catchError(_onError);
  }

  Future<List<Photo>> getFaceSearchResults(Face face) async {
    var futures = _dio
        .get(
          Configuration.instance.getHttpEndpoint() +
              "/photos/search/face/" +
              face.faceID.toString(),
          options: Options(
              headers: {"X-Auth-Token": Configuration.instance.getToken()}),
        )
        .then((response) => (response.data["results"] as List)
            .map((result) => (PhotoDB.instance.getPhotoByPath(result))));
    return Future.wait(await futures);
  }

  void _onError(error) {
    logger.severe(error);
  }
}
