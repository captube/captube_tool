import 'package:captube/datamodels/captured_item_model.dart';
import 'package:captube/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:captube/services/api.dart';

class CapturedViewModel extends ChangeNotifier {
  final _api = locator<Api>();

  List<String> _ids;
  List<String> get ids => _ids;

  List<CapturedItemModel> _captureds;
  List<CapturedItemModel> get captureds => _captureds;

  Future getCaptured(String url, String lang) async {
    var detailResults = await _api.fetchData(url, lang);

    if (detailResults is String) {
      // show error
    } else {
      _captureds = detailResults;
    }

    notifyListeners();
  }
}
