import 'package:crypto_app/core/failure/failure.dart';

/// A sealed class representing an either type, which can hold a value of type [L] (left) or [R] (right).
sealed class Either<L, R> {
  /// Constructs an instance of [Either] with a value of type [L] (left).
  factory Either.left(L left) = Left<L, R>;

  /// Constructs an instance of [Either] with a value of type [R] (right).
  factory Either.right(R right) = Right<L, R>;

  /// Creates an [Either] from a [Future] that may complete with a value of type [R].
  ///
  /// If [throwException] is `true`, any exception thrown during the [Future] execution will be rethrow.
  /// Otherwise, the exception will be caught and wrapped in a [Left] instance.
  static Future<Either<Failure, R>> fromFuture<R>(
    Future<R> future, {
    bool throwException = false,
  }) async {
    try {
      return Right<Failure, R>(await future);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      if (throwException) rethrow;
      return Left<Failure, R>(Failure(e.toString()));
    }
  }

  /// Creates an [Either] from a [Future] function that returns a value of type [R].
  ///
  /// If [throwException] is `true`, any exception thrown during the function execution will be rethrow.
  /// Otherwise, the exception will be caught and wrapped in a [Left] instance.
  static Future<Either<Failure, R>> fromFunction<R>(
    Future<R> Function() future, {
    bool throwException = false,
  }) async {
    try {
      return Right(await future());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      if (throwException) rethrow;
      return Left(Failure(e.toString()));
    }
  }

  /// Creates an [Either] from an [Exception].
  static Either<Failure, R> fromException<R>(Exception e) {
    return Left<Failure, R>(Failure(e.toString()));
  }
}

/// Represents the left side of an [Either].
class Left<L, R> implements Either<L, R> {
  /// Constructs a [Left] instance with a value of type [L].
  const Left(this.left);

  /// The value of type [L].
  final L left;

  @override
  String toString() => 'Left<$L, $R>($left)';
}

/// Represents the right side of an [Either].
class Right<L, R> implements Either<L, R> {
  /// Constructs a [Right] instance with a value of type [R].
  const Right(this.right);

  /// The value of type [R].
  final R right;

  @override
  String toString() => 'Right<$L, $R>($right)';
}

/// Extension methods for the [Either] class.
extension EitherExtension<L, R> on Either<L, R> {
  /// Returns the value of type [L] if this [Either] is a [Left], otherwise returns `null`.
  L? get left => (this is Left<L, R>) ? (this as Left<L, R>).left : null;

  /// Returns the value of type [R] if this [Either] is a [Right], otherwise returns `null`.
  R? get right => (this is Right<L, R>) ? (this as Right<L, R>).right : null;

  /// Returns `true` if this [Either] is a [Left], otherwise returns `false`.
  bool get isLeft => this is Left<L, R>;

  /// Returns `true` if this [Either] is a [Right], otherwise returns `false`.
  bool get isRight => this is Right<L, R>;

  /// Applies the appropriate function based on whether this [Either] is a [Left] or a [Right].
  ///
  /// If this [Either] is a [Left], the [left] function is applied to the value of type [L].
  /// If this [Either] is a [Right], the [right] function is applied to the value of type [R].
  ///
  /// Returns the result of applying the appropriate function.
  W fold<W>(
    W Function(L left) left,
    W Function(R right) right,
  ) {
    if (this is Left<L, R>) {
      return left((this as Left<L, R>).left);
    } else if (this is Right<L, R>) {
      return right((this as Right<L, R>).right);
    } else {
      throw Exception('Unhandled Either case');
    }
  }
}
