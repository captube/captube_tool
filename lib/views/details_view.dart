import 'dart:convert';
import 'dart:html' as html;

import 'package:captube/datamodels/detail_item_model.dart';
import 'package:captube/viewmodels/episode_details_view_model.dart';
import 'package:captube/widgets/detail_list/details_list.dart';
import 'package:flutter/material.dart';
//import 'package:captube/widgets/detail_list/details_list.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as ImageDart;
import 'package:provider_architecture/viewmodel_provider.dart';

class DetailsView extends StatelessWidget {
  final String id;

  const DetailsView({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<EpisodeDetailsViewModel>.withConsumer(
      viewModel: EpisodeDetailsViewModel(),
      onModelReady: (model) => model.getDetail(id),
      builder: (context, model, child) => SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          model.isInProgressSaveAsImage
              ? CircularProgressIndicator()
              : RaisedButton(
                  child: Text("Save as jpeg"),
                  onPressed: () {
                    model.isInProgressSaveAsImage = true;
                    mergeImages(model.details);
                    model.isInProgressSaveAsImage = false;
                  },
                ),
          model.details == null
              ? CircularProgressIndicator()
//               CircularProgressIndicator()
              : DetailList(details: model.details),
        ],
      )),
    );
  }

  void mergeImages(List<DetailItemModel> detailItems) async {
    if (detailItems == null) {
      return;
    }

    final imageFutures =
        detailItems.map((detailItem) => (http.get(detailItem.url)));
    final imageResponses = await Future.wait(imageFutures);
    final detailImages = imageResponses
        .map((response) => ImageDart.decodeImage(response.bodyBytes));

    final mergedImage = ImageDart.Image(
        detailImages.first.width,
        (detailImages.first.height * detailImages.length +
            10 * (detailImages.length - 1)));

    final mergeFutures = List<Future>();
    for (var index = 0; index < detailImages.length; index++) {
      final image = detailImages.elementAt(index);
      mergeFutures.add(Future(() => ImageDart.copyInto(mergedImage, image,
          dstY: index == 0 ? 0 : index * (image.height + 10), blend: false)));
    }
    await Future.wait(mergeFutures);

    final mergedImageAsUrl = "data:image/jpeg;base64," +
        base64Encode(ImageDart.encodeJpg(mergedImage));

    downloadFile(mergedImageAsUrl);
  }

  void downloadFile(String url) {
    html.AnchorElement anchorElement = new html.AnchorElement(href: url);
    anchorElement.href = url;
    anchorElement.download = "captube.jpg";
    anchorElement.click();
  }
}
