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
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // TODO: implement toString
    return "capture";
  }

  @override
  _CaptureViewState createState() => _CaptureViewState();
}

class _CaptureViewState extends State<CaptureView> {
  //final _api = locator<Api>();
  final NavigationService _navigationService = locator<NavigationService>();

  //bool _isLangChecked = false;
  String _valLanguage;
  bool _isLangChecked = false;
  bool _isLangSelected = false;
  bool _isLangNotNull = false;
  //var _captured;
  bool _isLangLoading = false;
  //var _data = "";
  List<dynamic> _dataLang = List();
  //var _apiURL = 'http://captube.net/api/v2/capture';
  String _url;

  static const String _apiEndpoint = 'http://captube.net/api/v2';

  void getLanguages(url) async {
    setState(() {
      _isLangLoading = true;
      _isLangChecked = false;
    });

    String _url = url.toString();

    final response = await http.get('$_apiEndpoint/capture/language?url=$_url');
    if (response.statusCode == 200) {
      var listData = jsonDecode(response.body);
      setState(() {
        _dataLang = listData['languages'] as List;
        print(_dataLang);
        _isLangNotNull = true;
        _isLangChecked = true;
        _isLangSelected = false;
        _isLangLoading = false;
      });
      //return 'Could not fetch the episodes at this time';
    } else {
      setState(() {
        //_dataLang = listData['languages'] as List;
        print("not 200 response");
        _isLangNotNull = false;
        _isLangChecked = true;
        _isLangSelected = false;
        _isLangLoading = false;
      });
    }
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
            //labelText: "Video URL",
            hintText: "Video URL",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: _isLangLoading
                  ? CircularProgressIndicator()
                  : IconButton(
                      icon: Icon(Icons.subtitles),
                      onPressed: () {
                        print('press!!');
                        _url = _controller.text.toString();
                        getLanguages(_url);
                      } //=> _handleSubmitted(_textController.text)),
                      ),
            ),
            suffixIconConstraints: BoxConstraints(
              minHeight: 25,
              minWidth: 25,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        /*_isLangLoading
            ? CircularProgressIndicator()
            : RaisedButton(
                child: Text("Language"),
                onPressed: () {
                  print('press!!');
                  _url = _controller.text.toString();
                  getLanguages(_url);
                },
              ),*/
        _isLangChecked
            ? _isLangNotNull
                ? DropdownButton(
                    hint: Text("language"),
                    value: _valLanguage,
                    items: _dataLang
                        .map<DropdownMenuItem<dynamic>>((dynamic value) {
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
                : Text("\nThe URL don't have subtitle info!")
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
