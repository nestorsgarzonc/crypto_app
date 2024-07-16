enum CoinsOrder {
  ascendent(labelBackEnd: 'market_cap_asc'),
  descendent(labelBackEnd: 'market_cap_desc');

  const CoinsOrder({required this.labelBackEnd});

  final String labelBackEnd;
}
