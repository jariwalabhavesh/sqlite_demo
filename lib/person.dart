class Person {
  int id = 0;
  String name;
  String city;

  Person({this.id = 0, required this.name, required this.city});

  Map<String, dynamic> toMap() => {
        "name": name,
        "city": city,
      };

  factory Person.fromMap(Map<String, dynamic> json) => Person(
        id: json["id"],
        name: json["name"],
        city: json["city"],
      );
}
