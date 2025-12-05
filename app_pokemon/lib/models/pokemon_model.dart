class Pokemon {
  final int id;
  final String name;
  final String url;

  Pokemon({required this.id, required this.name, required this.url});

  String get imageUrl {
    return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png";
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final idString = url.split('/')[6]; 
    
    return Pokemon(
      id: int.parse(idString),
      name: json['name'],
      url: url,
    );
  }
}