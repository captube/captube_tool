import 'dart:convert';

import 'package:captube/datamodels/captured_item_model.dart';
import 'package:captube/locator.dart';
import 'package:captube/routing/route_names.dart';
import 'package:captube/services/navigation_service.dart';
import 'package:captube/viewmodels/captured_view_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_builder/responsive_builder.dart';
//import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class CapturedView extends StatefulWidget {
  final String url;
  final String lang;

  CapturedView({this.url, this.lang /*, this.details*/
      });

  @override
  _CapturedViewState createState() => _CapturedViewState();
}

class _CapturedViewState extends State<CapturedView> {
  String title = 'CAPTUBE';
  bool visible_all = false;
  final NavigationService _navigationService = locator<NavigationService>();

  CapturedViewModel cvm = CapturedViewModel();
  final ScrollController _scrollController = ScrollController();

  //List<String> _ids;

  void getID([FirebaseAnalytics analytics]) async {
    var _apiURL = "http://captube.net/api/v2/archive";
    List<String> _ids = [];
    var _id;

    for (var i in cvm.captureds) {
      if (i.visible) {
        _id = i.id;
        _ids.add(_id);
        //_ids += '"$_id",';
        //_apiURL += "archiveItems=$_id&";
      }
    }
    title = cvm.title;
    var url = widget.url;

    var response;
    var a = json.encode(
        {"title": "$title", "thumbnailUrl": "$url", "archiveItems": _ids});
    print(a);

    if (analytics != null) {
      analytics.logEvent(name: "archive", parameters: {
        "view": "captured",
        "thumbnailUrl": "${widget.url}",
        "archiveItems": _ids
      });
    }

    try {
      response = await http.post(
        _apiURL,
        body: a,
        headers: {'Content-Type': "application/json"},
      );
      if (response.statusCode == 200) {
        response = json.decode(response.body)['id'];
        print("status code 200 id: $response");

        _navigationService
            .navigateTo(ArchiveRoute, queryParams: {'id': "$response"});
      } else {
        throw Exception('Failed to load data');
      }
    } catch (err) {
      var temp = json.decode(response.body)['message'];
      print('Caught error: $temp');
    }
  }

  final all = CapturedItemModel(url: 'All');

  //final notifications = [
  //  DetailItemRemov(url: 'Show Message'),
  //  DetailItemRemov(url: 'Show Group'),
  //  DetailItemRemov(url: 'Show Calling'),
  //  DetailItemRemov(url: 'Show Message'),
  //];
  @override
  Widget build(BuildContext context) {
    final analytics = FirebaseAnalytics();
    //_ids = fetchIDs(url, lang);

    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _scrollController,
                    child: Column(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: AppBar(
                            centerTitle: true,
                            title: //FlatButton(
                                //onPressed: () {
                                //  locator<NavigationService>()
                                //      .navigateTo(CaptureRoute);
                                //  print("pressed");
                                //},
                                //child:
                                Text(
                              "Select items",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            //padding: EdgeInsets.only(left: 12.0, right: 12.0),
                            //),
                            actions: <Widget>[
                              IconButton(
                                icon: Icon(Icons.play_circle_fill),
                                color: Colors.black,
                                onPressed: () async {
                                  analytics.logEvent(
                                      name: "playYoutube",
                                      parameters: {
                                        "view": "captured",
                                        "url": widget.url
                                      });
                                  if (await canLaunch(widget.url)) {
                                    await launch(
                                      widget.url,
                                      forceSafariVC: false,
                                    );
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.share),
                                color: Colors.black,
                                onPressed: () {
                                  getID(analytics);
                                },
                              ),
                            ],
                            elevation: 5.0,
                            backgroundColor: Colors.white,
                          )),
                      Expanded(
                          child: ViewModelBuilder<CapturedViewModel>.reactive(
                              viewModelBuilder: () => cvm,
                              onModelReady: (model) =>
                                  model.getCaptured(widget.url, widget.lang),
                              builder: (context, model, child) =>
                                  SingleChildScrollView(
                                      controller: _scrollController,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            model.isProgressing
                                                //model.captureds == null
                                                ? Column(children: <Widget>[
                                                    SizedBox(
                                                      height: 100.0,
                                                    ),
                                                    CircularProgressIndicator()
                                                  ])
                                                : model.captureds == null
                                                    ? Column(children: <Widget>[
                                                        Text(model.err),
                                                        AlertDialog(
                                                          title: Row(children: [
                                                            Icon(Icons.error),
                                                            Text(
                                                                '  Something went wrong ')
                                                          ]),
                                                          content: Text(
                                                              'Please report the error to (captube.help@gmail.com)'),
                                                          // Message which will be pop up on the screen
                                                          // Action widget which will provide the user to acknowledge the choice
                                                          actions: [
                                                            TextButton(
                                                              // FlatButton widget is used to make a text to work like a button
                                                              onPressed: () {
                                                                analytics.logEvent(
                                                                    name:
                                                                        "goBackCapture",
                                                                    parameters: {
                                                                      "view":
                                                                          "captured",
                                                                    });
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              },
                                                              // function used to perform after pressing the button
                                                              child: Text(
                                                                  'Go back'),
                                                            )
                                                          ],
                                                        )
                                                      ])
                                                    : Column(children: <Widget>[
                                                        Container(height: 10),
                                                        buildToggleCheckbox(
                                                            visible_all),
                                                        Divider(),
                                                        ...model.captureds
                                                            .map(
                                                                buildSingleCheckbox)
                                                            .toList(),
                                                        Container(height: 65),
                                                      ])
                                          ]))))
                    ])))),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            getID(analytics);
          },
          label: Text('Next'),
          icon: Icon(Icons.share),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }

  Widget buildSingleCheckbox(CapturedItemModel cim) => buildCheckbox(
        cim: cim,
        onClicked: () {
          setState(() {
            final newValue = !cim.visible;
            cim.visible = newValue;

            if (!newValue) {
              all.visible = false;
            } else {
              final allow = cvm.captureds.every((cvm) => cvm.visible);
              all.visible = allow;
            }
          });
        },
      );

  Widget buildCheckbox({
    @required CapturedItemModel cim,
    @required VoidCallback onClicked,
  }) =>
      CheckboxListTile(
        title: Image.network(cim.url),
        controlAffinity: ListTileControlAffinity.leading,
        value: cim.visible,
        onChanged: (value) => onClicked(),
      );

  Widget buildCheckboxAll(
          {@required bool value, @required VoidCallback onClicked}) =>
      CheckboxListTile(
        title: Text(
          'All',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: value,
        onChanged: (value) => onClicked(),
      );

  Widget buildToggleCheckbox(bool value /*CapturedItemModel cim*/) =>
      buildCheckboxAll(
          value: value,
          onClicked: () {
            final newValue = !value;

            setState(() {
              visible_all = newValue;
              cvm.captureds.forEach((cim) {
                cim.visible = newValue;
              });
            });
          });
}
