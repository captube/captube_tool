import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:captube/widgets/navigation_bar.dart';
//import 'package:path/path.dart';

class LayoutTemplate extends StatelessWidget {
  final Widget childView;
  const LayoutTemplate({Key key, this.childView}) : super(key: key);

  void showFAB() {}

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, sizingInformation) => Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                //padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 690),
                  child: Column(
                    children: <Widget>[
                      NavigationBar(),
                      Expanded(
                        child: childView,
                      )
                    ],
                  ),
                ),
              ),
              floatingActionButton: Visibility(
                child: FloatingActionButton.extended(
                  onPressed: () {
                    print(key.toString());
                  },
                  label: Text('Share'),
                  icon: Icon(Icons.share),
                  backgroundColor: Colors.red,
                ),
                visible: false,
              ),
            ));
  }

  /*Widget _getFAB() {
    if (orderList.isEmpty) {
      return Container();
    } else {
      return FloatingActionButton.extended(
        onPressed: () {
          print(childView.toString());
        },
        label: Text('Share'),
        icon: Icon(Icons.share),
        backgroundColor: Colors.red,
      );
    }
  }*/
}
