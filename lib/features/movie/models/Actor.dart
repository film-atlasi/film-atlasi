class Actor {
  final String name;
  final String character;
  final String? profilePhotoUrl;

  Actor({
    required this.name,
    required this.character,
    this.profilePhotoUrl,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      name: json['name'] ?? 'Bilinmeyen Oyuncu',
      character: json['character'] ?? 'Bilinmeyen Karakter',
      profilePhotoUrl: json['profile_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['profile_path']}'
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'character': character,
      'profile_path': profilePhotoUrl,
    };
  }
}
