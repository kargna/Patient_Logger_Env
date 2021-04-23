class MedicineModel {
  int id;
  String name;
  int totalDoses;
  int doseCounter;
  String days;
  String time;

  MedicineModel(this.name, this.totalDoses, this.doseCounter, this.days, this.time);
  MedicineModel.withId({this.id, this.name, this.totalDoses, this.doseCounter, this.days, this.time});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["total_doses"] = totalDoses;
    map["dose_counter"] = doseCounter;
    map["days"] = days;
    map["time"] = time;
    return map;
  }

  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    return MedicineModel.withId(
      id: map["id"],
      name: map["name"],
      totalDoses: map["total_doses"],
      doseCounter: map["dose_counter"],
      days: map["days"],
      time: map["time"],
    );
  }
}