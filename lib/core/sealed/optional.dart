/// A sealed class representing an optional value.
///
/// An [Optional] can either have a value ([Some]) or be empty ([None]).
sealed class Optional<T> {
  const Optional();

  /// Creates an [Optional] with a non-null value.
  const factory Optional.some(T value) = Some<T>;

  /// Creates an empty [Optional].
  const factory Optional.none() = None<T>;
}

/// Represents an [Optional] value with a non-null value.
class Some<T> extends Optional<T> {
  const Some(this.value);

  /// The value of the [Some] instance.
  final T value;

  @override
  bool operator ==(covariant Some<T> other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// Represents an empty [Optional] value.
class None<T> extends Optional<T> {
  const None();
}

/// Extension methods for the [Optional] class.
extension OptionalExtension<T> on Optional<T> {
  /// Returns the value of the [Optional] if it is a [Some], otherwise returns null.
  T? get value => (this is Some<T>) ? (this as Some<T>).value : null;

  /// Returns true if the [Optional] is a [Some], otherwise returns false.
  bool get isSome => this is Some<T>;

  /// Returns true if the [Optional] is a [None], otherwise returns false.
  bool get isNone => this is None<T>;

  /// Applies the provided functions to the value of the [Optional].
  ///
  /// If the [Optional] is a [Some], the [some] function is applied to the value.
  /// If the [Optional] is a [None], the [none] function is applied.
  W fold<W>(W Function(T) some, W Function() none) {
    if (this is Some<T>) {
      return some((this as Some<T>).value);
    } else {
      return none();
    }
  }

  /// Returns the [Optional] if it is a [Some], otherwise returns the result of calling the [other] function.
  Optional<T> orElse(Optional<T> Function() other) {
    if (this is Some<T>) {
      return this;
    } else {
      return other();
    }
  }
}
