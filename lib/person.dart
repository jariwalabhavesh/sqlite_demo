class Person {
  int id = 0;
  String name;
  String city;

  Person({this.id = 0, required this.name, required this.city});

  // Convert a Person into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() => {
        "name": name,
        "city": city,
      };

  // Convert the List<Map<String, dynamic> into a List<Person>.
  factory Person.fromMap(Map<String, dynamic> json) => Person(
        id: json["id"],
        name: json["name"],
        city: json["city"],
      );
}
