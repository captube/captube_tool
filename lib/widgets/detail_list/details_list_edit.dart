import 'package:captube/datamodels/captured_item_model.dart';
import 'package:captube/widgets/detail_list/detail_item_removable.dart';
import 'package:flutter/material.dart';
import 'package:captube/datamodels/detail_item_model.dart';

class DetailListEdit extends StatelessWidget {
  final List<CapturedItemModel> details;
  DetailListEdit({this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      //spacing: 10,
      //runSpacing: 10,
      children: <Widget>[
        Container(height: 10),
        ...details.map(
          (detail) => DetailItemRemov(model: detail),
        ),
        Container(
            height: 300, // 높이를 360으로 지정
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {},
                    child: const Text('Save', style: TextStyle(fontSize: 20)),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: const Text('Copy as URL',
                        style: TextStyle(fontSize: 20)),
                  )
                ]))
      ],
    );
  }
}
