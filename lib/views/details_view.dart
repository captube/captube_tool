import 'dart:convert';
import 'dart:html' as html;
import 'package:clipboard/clipboard.dart';
import 'package:captube/locator.dart';
import 'package:captube/routing/route_names.dart';
import 'package:captube/services/navigation_service.dart';
//import 'package:captube/widgets/navigation_bar.dart';

import 'package:captube/datamodels/detail_item_model.dart';
import 'package:captube/viewmodels/episode_details_view_model.dart';
import 'package:captube/widgets/detail_list/details_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//import 'package:captube/widgets/detail_list/details_list.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as ImageDart;
import 'package:provider_architecture/viewmodel_provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsView extends StatefulWidget {
  DetailsView({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _DetailsViewState createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  bool _isMakingImg = false;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
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
                        child: ViewModelProvider<
                                EpisodeDetailsViewModel>.withConsumer(
                            viewModel: EpisodeDetailsViewModel(),
                            onModelReady: (model) => model.getDetail(widget.id),
                            builder: (context, model, child) =>
                                Column(children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: AppBar(
                                        centerTitle: true,
                                        title: FlatButton(
                                          onPressed: () {
                                            locator<NavigationService>()
                                                .navigateTo(CaptureRoute);
                                            print("pressed");
                                          },
                                          child: Text(
                                            model.title.toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 12.0, right: 12.0),
                                        ),
                                        actions: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.copy),
                                            color: Colors.black,
                                            onPressed: () {
                                              final url = widget.id;
                                              FlutterClipboard.copy(
                                                      'http://captube.net/#/archive?id=$url')
                                                  .then((value) => print(
                                                      'copied: http://captube.net/#/archive?id=$url'));
                                            },
                                          ),
                                          _isMakingImg
                                              ? Container(
                                                  height: 25,
                                                  width: 25,
                                                  margin: EdgeInsets.all(8),
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : IconButton(
                                                  icon:
                                                      Icon(Icons.file_download),
                                                  color: Colors.black,
                                                  onPressed: () {
                                                    mergeImages(model.details);
                                                  },
                                                )
                                        ],
                                        elevation: 5.0,
                                        backgroundColor: Colors.white,
                                      )),
                                  Expanded(
                                      child: SingleChildScrollView(
                                          controller: _scrollController,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              RichText(
                                                  //textAlign: TextAlign.end,
                                                  text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    text: 'Watch this on ',
                                                  ),
                                                  TextSpan(
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                    text: 'YouTube',
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () async {
                                                            final url =
                                                                model.url;
                                                            if (await canLaunch(
                                                                url)) {
                                                              await launch(
                                                                url,
                                                                forceSafariVC:
                                                                    false,
                                                              );
                                                            }
                                                          },
                                                  ),
                                                ],
                                              )),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              model.details == null
                                                  ? CircularProgressIndicator()
                                                  : DetailList(
                                                      details: model.details),
                                              Container(height: 65),
                                            ],
                                          ))),
                                ])))))));
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
        detailImages.last.width,
        (detailImages.last.height * detailImages.length +
            10 * (detailImages.length - 1)));

    final mergeFutures = List<Future>();
    for (var index = 0; index < detailImages.length; index++) {
      final image = detailImages.elementAt(index);
      if (index == 0) {
        final half = ImageDart.copyResize(image, width: 640);
        mergeFutures.add(Future(() => ImageDart.copyInto(mergedImage, half,
            dstY: index == 0 ? 0 : index * (half.height + 10), blend: false)));
      } else {
        mergeFutures.add(Future(() => ImageDart.copyInto(mergedImage, image,
            dstY: index == 0 ? 0 : index * (image.height + 10), blend: false)));
      }
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
