import 'dart:convert';

import 'package:captube/datamodels/captured_item_model.dart';
import 'package:captube/routing/route_names.dart';
import 'package:captube/services/navigation_service.dart';
import 'package:captube/locator.dart';
import 'package:captube/widgets/detail_list/detail_item_removable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailListEdit extends StatefulWidget {
  final List<CapturedItemModel> details;
  DetailListEdit({this.details});

  @override
  _DetailListEditState createState() => _DetailListEditState();
}

class _DetailListEditState extends State<DetailListEdit> {
  final NavigationService _navigationService = locator<NavigationService>();

  List<String> _ids;

  void getID() async {
    var _apiURL = "http://captube.net/api/v2/archive?";
    //_apiURL += "archiveItems=P7QxmzMxV2c_en_1&archiveItems=P7QxmzMxV2c_en_10";

    var _id;
    for (var i in widget.details) {
      if (i.visible) {
        _id = i.id;
        _apiURL += "archiveItems=$_id&";
      }
    }

    if (_apiURL.endsWith('&')) {
      _apiURL = _apiURL.substring(0, _apiURL.length - 1);
    }

    //print('getID function /w ids: $ids');
    var response;

    try {
      response = await http.post(
        _apiURL,
        headers: {'accept': "application/json"},
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
      //response = '$err';
      print('Caught error: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    //List<String> _visibles;
    //var _id;
    //Scaffold.of(context)._showFAB();

    return Column(
      //spacing: 10,
      //runSpacing: 10,
      children: <Widget>[
        Container(
            height: 300, // 높이를 360으로 지정
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      //_visibles = getVisibles();
                      getID();
                    },
                    child: const Text('Share', style: TextStyle(fontSize: 20)),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: const Text('Copy as URL',
                        style: TextStyle(fontSize: 20)),
                  )
                ])),
        Container(height: 10),
        ...widget.details.map(
          (e) => DetailItemRemov(model: e),
        )
      ],
    );
  }
}
