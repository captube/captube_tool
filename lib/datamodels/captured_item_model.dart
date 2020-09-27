class CapturedItemModel {
  //final String title;
  final String id;
  final String imageUrl;
  bool visible = true;

  CapturedItemModel({
    //this.title,
    this.id,
    this.imageUrl,
    this.visible,
  });

  CapturedItemModel.fromJson(Map<String, dynamic> map)
      : //title = map['title'],
        id = map['id'],
        imageUrl = map['url'];
  //visible = true;
}
