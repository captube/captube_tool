import 'dart:convert';
import 'package:captube/routing/route_names.dart';
import 'package:captube/services/navigation_service.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:captube/locator.dart';
//import 'package:captube/services/api.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CaptureView extends StatefulWidget {
  CaptureView({Key key, this.title}) : super(key: key);
  final String title;

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

  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, sizingInformation) => Scaffold(
            backgroundColor: Colors.white,
            body: Container(
                //padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Column(children: <Widget>[
                      //NavigationBar(),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          alignment: Alignment.topCenter,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 100.0,
                                ),
                                Text(
                                  'CapTube',
                                  style: TextStyle(
                                    fontSize: 60.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 50.0,
                                ),
                                TextField(
                                  controller: _controller,
                                  onSubmitted: (String value) {
                                    print('$value press!!');
                                    _url = _controller.text.toString();
                                    getLanguages(_url);
                                  },
                                  decoration: InputDecoration(
                                    //labelText: "Video URL",
                                    hintText: "Video URL",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 0.0, 10.0, 0.0),
                                      child: _isLangLoading
                                          ? CircularProgressIndicator()
                                          : IconButton(
                                              icon: Icon(Icons.arrow_right_alt),
                                              onPressed: () {
                                                print('press!!');
                                                _url =
                                                    _controller.text.toString();
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
                                _isLangChecked
                                    ? _isLangNotNull
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                                Text('languages'),
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0,
                                                            right: 15.0),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3.0),
                                                        border: Border.all()),
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton(
                                                      hint: Text("language"),
                                                      value: _valLanguage,
                                                      items: _dataLang.map<
                                                              DropdownMenuItem<
                                                                  dynamic>>(
                                                          (dynamic value) {
                                                        return DropdownMenuItem<
                                                            dynamic>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _valLanguage = value;
                                                          print(_valLanguage);
                                                          _isLangSelected =
                                                              true;
                                                        });
                                                      },
                                                    ))),
                                              ])
                                        : Text(
                                            "\nThe URL don't have subtitle info!")
                                    : SizedBox(
                                        height: 20.0,
                                      ),
                                _isLangSelected
                                    ? Column(children: <Widget>[
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        ButtonTheme(
                                            minWidth: 360.0,
                                            height: 50.0,
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3.0),
                                              ),
                                              child: Text("Capture!"),
                                              onPressed: () {
                                                _navigationService.navigateTo(
                                                    CapturedRoute,
                                                    queryParams: {
                                                      'url': _url,
                                                      'lang': _valLanguage
                                                    });
                                                //CapturedViewModel().navigateToEpisode(_url, _valLanguage);
                                                //_fetchData(_url);
                                              },
                                            )),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        RichText(
                                            text: TextSpan(
                                          children: [
                                            TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              text:
                                                  'By capturing, you agree to our ',
                                            ),
                                            TextSpan(
                                              style:
                                                  TextStyle(color: Colors.blue),
                                              //style: bodyTextStyle.copyWith(
                                              //color: colorScheme.primary,
                                              //),
                                              text: 'Terms and Conditions',
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () async {
                                                  final url =
                                                      'https://www.notion.so/hyoeunlee/CapTube-Terms-Conditions-3798069facde49b6985f2f99b98af973';
                                                  if (await canLaunch(url)) {
                                                    await launch(
                                                      url,
                                                      forceSafariVC: false,
                                                    );
                                                  }
                                                },
                                            ),
                                            TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              text: '.',
                                            ),
                                          ],
                                        ))
                                      ]
                                        //Text(
                                        //'By capturing, you agree to our Terms and Conditions and Privacy Policy',
                                        //style: TextStyle(
                                        // fontSize: 9.0,
                                        //),
                                        //)
                                        //]
                                        //)
                                        )
                                    : SizedBox(
                                        height: 20.0,
                                      )
                              ]),
                        ),
                      )
                    ])))));
  }
}
