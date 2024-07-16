class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => message;

  @override
  bool operator ==(covariant Failure other) {
    if (identical(this, other)) return true;
    return other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
