class DetailItemModel {
  final String id;
  final String url;
  final timestamp;
  final String subtitle;
  final String videoId;

  DetailItemModel({
    this.id,
    this.url,
    this.timestamp,
    this.subtitle,
    this.videoId,
  });

  DetailItemModel.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        url = map['url'],
        timestamp = int.parse(
                map['id'].toString().replaceAll(new RegExp(r'[^0-9]'), '')) +
            1,
        subtitle = map['subtitle'],
        videoId = map['videoId'];
}
