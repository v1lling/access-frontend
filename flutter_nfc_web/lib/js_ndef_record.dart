class JsNdefRecord {
  JsNdefRecord(
      {this.data,
      this.encoding,
      this.id,
      this.lang,
      this.mediaType,
      this.recordType});
  final String? data;
  final String? encoding;
  final String? id;
  final String? lang;
  final String? mediaType;
  final String? recordType;

  factory JsNdefRecord.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return JsNdefRecord();
    final data = json['data'];
    final encoding = json['encoding'];
    final id = json['id'];
    final lang = json['lang'];
    final mediaType = json['mediaType'];
    final recordType = json['recordType'];
    return JsNdefRecord(
        data: data,
        encoding: encoding,
        id: id,
        lang: lang,
        mediaType: mediaType,
        recordType: recordType);
  }

  factory JsNdefRecord.empty() {
    return JsNdefRecord();
  }

  Map<String, dynamic> toJson() => {
        'data': data,
        'encoding': encoding,
        'id': id,
        'lang': lang,
        'mediaType': mediaType,
        'recordType': recordType
      };

  @override
  List<Object> get props =>
      [data!, encoding!, id!, lang!, mediaType!, recordType!];
}
