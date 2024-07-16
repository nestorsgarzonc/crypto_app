sealed class Optional<T> {
  const Optional();

  const factory Optional.some(T value) = Some<T>;
  const factory Optional.none() = None<T>;
}

class Some<T> extends Optional<T> {
  const Some(this.value);

  final T value;

  @override
  bool operator ==(covariant Some<T> other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class None<T> extends Optional<T> {
  const None();
}

extension OptionalExtension<T> on Optional<T> {
  T? get value => (this is Some<T>) ? (this as Some<T>).value : null;

  bool get isSome => this is Some<T>;
  bool get isNone => this is None<T>;

  W fold<W>(W Function(T) some, W Function() none) {
    if (this is Some<T>) {
      return some((this as Some<T>).value);
    } else {
      return none();
    }
  }

  Optional<T> orElse(Optional<T> Function() other) {
    if (this is Some<T>) {
      return this;
    } else {
      return other();
    }
  }
}
