import 'package:captube/datamodels/captured_item_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:captube/datamodels/detail_item_model.dart';

class Api {
  static const String _apiEndpoint = 'http://captube.net/api/v2';

  // Future<dynamic> fetchData(String url, String lang) async {
  //   var _apiURL = "http://captube.net/api/v2/capture";
  //   print('Calling API /w url: $url && $lang');
  //   var response;
  //   var _data;
  //   //var _captured2;
  //   var _captured1;
  //   //var _captured;
  //   try {
  //     response = await http.post(
  //       _apiURL,
  //       body: jsonEncode({
  //         'url': '$url',
  //         'language': '$lang',
  //       }),
  //       headers: {'Content-Type': "application/json"},
  //     );
  //     if (response.statusCode == 200) {
  //       _data = json.decode(response.body)['id'];
  //       print(_data);

  //       _captured1 = (json.decode(response.body)['captureItems'] as List)
  //           .map((detail) => CapturedItemModel.fromJson(detail))
  //           .toList();
  //       //_captured1.sort();
  //       //_captured1.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  //       print("Response: ${response.statusCode}");
  //       print("     ?     ");
  //       return _captured1;
  //     } else {
  //       return response.body;
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (err) {
  //     _data = '$err';
  //     print('Caught error: $err');
  //   }
  // }

  Future<dynamic> getDetails(id) async {
    var response2;
    String _id = id;

    response2 = await http.get('$_apiEndpoint/archive/$_id');
    if (response2.statusCode == 200) {
      var details = (json.decode(response2.body)['items'] as List)
          .map((detail) => DetailItemModel.fromJson(detail))
          .toList();
      details.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return details;
    }

    // something wrong happened
    return 'Could not fetch the episodes at this time';
  }
}
