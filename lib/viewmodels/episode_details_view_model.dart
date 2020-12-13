import 'package:captube/datamodels/detail_item_model.dart';
import 'package:captube/locator.dart';
import 'package:captube/services/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EpisodeDetailsViewModel extends ChangeNotifier {
  static const String _apiEndpoint = 'http://captube.net/api/v2';
  final _api = locator<Api>();

  var title;
  var url;
  List<DetailItemModel> _details;

  List<DetailItemModel> get details => _details;
  bool isInProgressSaveAsImage = false;

  Future getDetail(String id) async {
    var detailResults; // = await _api.getDetails(id);
    //var details;
    var response2;
    String _id = id;

    response2 = await http.get('$_apiEndpoint/archive/$_id');
    if (response2.statusCode == 200) {
      title = json.decode(response2.body)['title'];
      url = json.decode(response2.body)['thumbnailUrl'];
      print(title + " asb " + url);
      var details = (json.decode(response2.body)['items'] as List)
          .map((detail) => DetailItemModel.fromJson(detail))
          .toList();
      details.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      detailResults = details;
    }

    if (detailResults is String) {
      // show error
    } else {
      _details = detailResults;
    }

    notifyListeners();
  }
}
