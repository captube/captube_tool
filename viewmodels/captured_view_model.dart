//import 'dart:html';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:captube/datamodels/captured_item_model.dart';
import 'package:captube/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:captube/services/api.dart';

class CapturedViewModel extends ChangeNotifier {
  final _api = locator<Api>();

  List<String> _ids;
  List<String> get ids => _ids;

  var title = "CAPTUBE";
  var url;

  String err;
  bool isProgressing = true;

  List<CapturedItemModel> _captureds;
  List<CapturedItemModel> get captureds => _captureds;

  Future getCaptured(String url, String lang) async {
    var detailResults;
    //= await _api.fetchData(url, lang);

    var _apiURL = "http://captube.net/api/v2/capture";
    print('Calling API /w url: $url && $lang');
    var response;
    //var _title;
    //var _data;
    var _captured1;
    try {
      response = await http.post(
        _apiURL,
        body: jsonEncode({
          'url': '$url',
          'language': '$lang',
        }),
        headers: {'Content-Type': "application/json"},
      );
      if (response.statusCode == 200) {
        //_data = json.decode(response.body)['id'];
        title = json.decode(response.body)['title'];
        url = json.decode(response.body)['thumbnailUrl'];
//        print(title);

        _captured1 = (json.decode(response.body)['captureItems'] as List)
            .map((detail) => CapturedItemModel.fromJson(detail))
            .toList();
        //_captured1.sort();
        //_captured1.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        print("Response: ${response.statusCode}");
        print("     ?     ");
        detailResults = _captured1;
      } else {
        detailResults = response.body;
        throw Exception('Failed to load data');
      }
    } catch (err) {
      //_data = '$err';
      print('Caught error: $err');
    }

    if (detailResults is String) {
      // show error
      err = detailResults;
      print(err);
    } else {
      _captureds = detailResults;
    }
    isProgressing = false;
    notifyListeners();
  }
}
