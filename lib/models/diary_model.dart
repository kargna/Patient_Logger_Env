class DiaryModel {
  int id;
  DateTime date;
  String entry;

  DiaryModel(this.date, this.entry);
  DiaryModel.withId({this.id, this.date, this.entry});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map["id"] = id;
    map["date"] = date.toIso8601String();
    map["entry"] = entry;
    return map;
  }

  factory DiaryModel.fromMap(Map<String, dynamic> map) {
    return DiaryModel.withId(
        id: map["id"],
        entry: map["entry"],
        date: DateTime.parse(map["date"])
    );
  }
}