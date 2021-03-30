class CapturedItemModel /*implements Comparable<CapturedItemModel> */ {
  final String id;
  final String url;
  final timestamp;
  final String subtile;

  bool visible = false;

  CapturedItemModel({
    this.id,
    this.url,
    this.timestamp,
    this.subtile,
    this.visible,
  });

  CapturedItemModel.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        url = map['url'],
        timestamp = int.parse(
                map['id'].toString().replaceAll(new RegExp(r'[^0-9]'), '')) +
            1,
        //timestamp = map['frameNumber'],
        subtile = map['subtitle'];
  //visible = true;

  CapturedItemModel.fromJson2(String iid, String iurl, String title)
      : id = iid,
        url = iurl,
        timestamp = int.parse("0"),
        subtile = title;

  /*@override
  int compareTo(CapturedItemModel other) {
    // TODO: implement compareTo
    return this.timestamp - other.timestamp;
    //throw UnimplementedError();
  }*/
}
