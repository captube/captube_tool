import 'package:captube/viewmodels/captured_view_model.dart';
import 'package:captube/widgets/detail_list/details_list_edit.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

//import 'package:captube/viewmodels/episode_details_view_model.dart';
//import 'package:captube/widgets/detail_list/details_list.dart';

class CapturedView extends StatelessWidget {
  final String url;
  final String lang;

  const CapturedView({Key key, this.url, this.lang}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // TODO: implement toString
    return "captured";
  }

  @override
  Widget build(BuildContext context) {
    //_ids = fetchIDs(url, lang);

    return ViewModelProvider<CapturedViewModel>.withConsumer(
      viewModel: CapturedViewModel(),
      onModelReady: (model) => model.getCaptured(url, lang),
      builder: (context, model, child) => SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          model.captureds == null
              ? CircularProgressIndicator()
              : DetailListEdit(details: model.captureds),
        ],
      )),
    );
  }
}
