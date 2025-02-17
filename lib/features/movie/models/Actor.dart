class Actor {
  final String name;
  final int id; // Oyuncunun ID'si
  final String character;
  final String? profilePhotoUrl;

  Actor({
    required this.id,
    required this.name,
    required this.character,
    this.profilePhotoUrl,
  });

  factory Actor.fromJson(Map<dynamic, dynamic> json) {
    return Actor(
      id: json['id'], // Burada oyuncunun ID'sini alıyoruz

      name: json['name'] ?? 'Bilinmeyen Oyuncu',
      character: json['character'] ?? 'Bilinmeyen Karakter',
      profilePhotoUrl: json['profile_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['profile_path']}'
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'character': character,
      'profile_path': profilePhotoUrl,
    };
  }
}
