class CapturedItemModel {
  //final String title;
  final String id;
  final String imageUrl;

  CapturedItemModel({
    //this.title,
    this.id,
    this.imageUrl,
  });

  CapturedItemModel.fromJson(Map<String, dynamic> map)
      : //title = map['title'],
        id = map['id'],
        imageUrl = map['url'];
}
