import 'package:captube/datamodels/captured_item_model.dart';
import 'package:flutter/material.dart';
//import 'package:captube/datamodels/detail_item_model.dart';

class DetailItemRemov extends StatefulWidget {
  final CapturedItemModel model;
  const DetailItemRemov({Key key, this.model}) : super(key: key);

  @override
  _DetailItemRemove createState() => _DetailItemRemove();
}

//bool _deleted = false;

class _DetailItemRemove extends State<DetailItemRemov> {
  bool _visibiliT = true;

  void _changed() {
    setState(() {
      if (_visibiliT) {
        _visibiliT = false;
        widget.model.visible = false;
      } else {
        _visibiliT = true;
        widget.model.visible = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //bool _deleted = false;
    //deleted? deleted=false: deleted=true;
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: //Image.network(widget.model.url),
                _visibiliT ? Image.network(widget.model.imageUrl) : SizedBox(),
            /*,width: 640, height: 360*/
          ),
          IconButton(
              icon: _visibiliT ? Icon(Icons.delete_forever) : Icon(Icons.add),
              onPressed: () {
                print("$_visibiliT");
                _changed();
                print(" $_visibiliT");
              }),
        ]);
  }
}
