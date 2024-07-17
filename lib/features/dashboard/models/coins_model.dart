class CoinsModel {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final num currentPrice;
  final num marketCap;
  final int marketCapRank;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double? variation;

  bool get isPositiveVar => variation != null && variation! >= 0;

  const CoinsModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    this.variation,
  });

  CoinsModel copyWith({
    String? id,
    String? symbol,
    String? name,
    String? image,
    num? currentPrice,
    num? marketCap,
    int? marketCapRank,
    double? priceChange24h,
    double? priceChangePercentage24h,
    double? variation,
  }) {
    return CoinsModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      image: image ?? this.image,
      currentPrice: currentPrice ?? this.currentPrice,
      marketCap: marketCap ?? this.marketCap,
      marketCapRank: marketCapRank ?? this.marketCapRank,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      priceChangePercentage24h: priceChangePercentage24h ?? this.priceChangePercentage24h,
      variation: variation ?? this.variation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'price_change_24h': priceChange24h,
      'price_change_percentage_24h': priceChangePercentage24h,
    };
  }

  factory CoinsModel.fromMap(Map<String, dynamic> map) => CoinsModel(
        id: map['id'] as String,
        symbol: map['symbol'] as String,
        name: map['name'] as String,
        image: map['image'] as String,
        currentPrice: map['current_price'] as num,
        marketCap: map['market_cap'] as num,
        marketCapRank: map['market_cap_rank'] as int? ?? -1,
        priceChange24h: map['price_change_24h'] as double? ?? -1.0,
        priceChangePercentage24h: map['price_change_percentage_24h'] as double? ?? -1.0,
      );

  @override
  String toString() =>
      'CoinsModel(id: $id, symbol: $symbol, name: $name, image: $image, currentPrice: $currentPrice, marketCap: $marketCap, marketCapRank: $marketCapRank, priceChange24h: $priceChange24h, priceChangePercentage24h: $priceChangePercentage24h), variation: $variation';

  @override
  bool operator ==(covariant CoinsModel other) {
    if (identical(this, other)) return true;
    return other.id == id &&
        other.symbol == symbol &&
        other.name == name &&
        other.image == image &&
        other.currentPrice == currentPrice &&
        other.marketCap == marketCap &&
        other.marketCapRank == marketCapRank &&
        other.priceChange24h == priceChange24h &&
        other.variation == variation &&
        other.priceChangePercentage24h == priceChangePercentage24h;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      symbol.hashCode ^
      name.hashCode ^
      image.hashCode ^
      currentPrice.hashCode ^
      marketCap.hashCode ^
      marketCapRank.hashCode ^
      priceChange24h.hashCode ^
      variation.hashCode ^
      priceChangePercentage24h.hashCode;
}
