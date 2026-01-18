class RelicItem {
  final String id;
  String name;
  String imageUrl;
  String? localImagePath;
  int counter;
  int intact;
  int exceptional;
  int flawless;
  int radiant;
  String condition;
  String type;

  RelicItem(
      {required this.id,
      required this.name,
      required this.imageUrl,
      this.condition = "intact",
      this.localImagePath,
      this.counter = 0,
      this.intact = 0,
      this.exceptional = 0,
      this.flawless = 0,
      this.radiant = 0,
      this.type = ""});

  factory RelicItem.fromJson(Map<String, dynamic> json) {
    return RelicItem(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      localImagePath: json['localImagePath'] as String?,
      counter: (json['counter'] as num?)?.toInt() ?? 0,
      intact: (json['intact'] as num?)?.toInt() ?? 0,
      exceptional: (json['exceptional'] as num?)?.toInt() ?? 0,
      flawless: (json['flawless'] as num?)?.toInt() ?? 0,
      radiant: (json['radiant'] as num?)?.toInt() ?? 0,
      condition: json['condition'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'localImagePath': localImagePath,
        'counter': counter,
        'intact': intact,
        'exceptional': exceptional,
        'flawless': flawless,
        'radiant': radiant,
        'condition': condition,
        'type': type,
      };

  RelicItem copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? localImagePath,
    int? counter,
    int? intact,
    int? exceptional,
    int? flawless,
    int? radiant,
    String? condition,
    String? type,
  }) {
    return RelicItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
      counter: counter ?? this.counter,
      intact: intact ?? this.intact,
      exceptional: exceptional ?? this.exceptional,
      flawless: flawless ?? this.flawless,
      radiant: radiant ?? this.radiant,
      condition: condition ?? this.condition,
      type: type ?? this.type,
    );
  }

  int get total => intact + exceptional + flawless + radiant;
}
