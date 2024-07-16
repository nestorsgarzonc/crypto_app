class UrlShort {
  const UrlShort({required this.alias, required this.short, required this.self});

  final String alias;
  final String short;
  final String self;

  factory UrlShort.fromJson(Map<String, dynamic> json) {
    return UrlShort(
      alias: json['alias'],
      short: json['_links']['short'],
      self: json['_links']['self'],
    );
  }

  @override
  bool operator ==(covariant UrlShort other) {
    if (identical(this, other)) return true;

    return other.alias == alias && other.short == short && other.self == self;
  }

  @override
  int get hashCode => alias.hashCode ^ short.hashCode ^ self.hashCode;
}
