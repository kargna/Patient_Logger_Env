class SymptomModel {
  int id;
  String name;
  double severity;
  String notes;

  SymptomModel(this.name, this.severity, this.notes);
  SymptomModel.withId({this.id, this.name, this.severity, this.notes});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["severity"] = severity;
    map["notes"] = notes;
    return map;
  }

  factory SymptomModel.fromMap(Map<String, dynamic> map) {
    return SymptomModel.withId(
        id: map["id"],
        name: map["name"],
        severity: map["severity"],
        notes: map["notes"],
    );
  }
}