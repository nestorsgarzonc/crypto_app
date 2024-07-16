extension ObjectExtension<G> on G {
  T let<T>(T Function(G it) block) => block(this);
}
