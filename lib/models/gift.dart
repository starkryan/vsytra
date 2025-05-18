class Gift {
  final String id;
  final String name;
  final int diamondValue;
  final String imageUrl;
  final String? animationUrl;
  final bool isSpecial;

  Gift({
    required this.id,
    required this.name,
    required this.diamondValue,
    required this.imageUrl,
    this.animationUrl,
    this.isSpecial = false,
  });

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      id: json['id'],
      name: json['name'],
      diamondValue: json['diamondValue'],
      imageUrl: json['imageUrl'],
      animationUrl: json['animationUrl'],
      isSpecial: json['isSpecial'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'diamondValue': diamondValue,
      'imageUrl': imageUrl,
      'animationUrl': animationUrl,
      'isSpecial': isSpecial,
    };
  }
}
