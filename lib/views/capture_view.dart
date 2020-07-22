import 'dart:convert';
import 'package:captube/routing/route_names.dart';
import 'package:captube/services/navigation_service.dart';
import 'package:http/http.dart' as http;

import 'package:captube/locator.dart';
import 'package:captube/services/api.dart';
import 'package:flutter/material.dart';

class CaptureView extends StatefulWidget {
  CaptureView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CaptureViewState createState() => _CaptureViewState();
}

class _CaptureViewState extends State<CaptureView> {
  final _api = locator<Api>();
  final NavigationService _navigationService = locator<NavigationService>();

  //bool _isLangChecked = false;
  String _valLanguage;
  bool _isLangLoaded = false;
  bool _isLangSelected = false;
  var _captured;
  bool _isLoading = false;
  var _data = "";
  List<dynamic> _dataLang = List();
  var _apiURL = 'http://captube.net/api/v2/capture';
  String _url;

  static const String _apiEndpoint = 'http://captube.net/api/v2';

  void getLanguages(url) async {
    setState(() {
      _isLangLoaded = false;
    });

    String _url = url.toString();

    final response = await http.get('$_apiEndpoint/capture/language?url=$_url');
    var listData = jsonDecode(response.body);
    setState(() {
      _dataLang = listData['languages'] as List;
      print(_dataLang);
      _isLangLoaded = true;
    });
    //return 'Could not fetch the episodes at this time';
  }

  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      alignment: Alignment.topCenter,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        SizedBox(
          height: 100.0,
        ),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: "Video URL",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        RaisedButton(
          child: Text("Language"),
          onPressed: () {
            _url = _controller.text.toString();
            getLanguages(_url);
          },
        ),
        _isLangLoaded
            ? DropdownButton(
                hint: Text("language"),
                value: _valLanguage,
                items:
                    _dataLang.map<DropdownMenuItem<dynamic>>((dynamic value) {
                  return DropdownMenuItem<dynamic>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _valLanguage = value;
                    print(_valLanguage);
                    _isLangSelected = true;
                  });
                },
              )
            : SizedBox(
                height: 20.0,
              ),
        _isLangSelected
            ? RaisedButton(
                child: Text("Capture!"),
                onPressed: () {
                  _navigationService.navigateTo(CapturedRoute,
                      queryParams: {'url': _url, 'lang': _valLanguage});
                  //CapturedViewModel().navigateToEpisode(_url, _valLanguage);
                  //_fetchData(_url);
                },
              )
            : SizedBox(
                height: 20.0,
              )
      ]),
/*            _isLoading
                ? CircularProgressIndicator()
                : //Text(""),
                //:_navigationService.navigateTo(EpisodeDetailsRoute, queryParams: {'id': _data})
                Text("$_data")
            //Text(_isLoading ? "Loading.." : _data),
          ],*/
    );
  }
}
