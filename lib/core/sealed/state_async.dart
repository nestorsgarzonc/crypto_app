import 'package:flutter/material.dart';
import 'package:crypto_app/core/failure/failure.dart';

// Represents the different states of an asynchronous operation.
///
/// The [StateAsync] class is a sealed class that defines four possible states:
/// - [AsyncLoadingC]: Represents the loading state of the operation.
/// - [AsyncInitial]: Represents the initial state of the operation.
/// - [AsyncDone]: Represents the successful completion of the operation with a value.
/// - [AsyncFailure]: Represents the failure of the operation with an error.
///
/// The [StateAsync] class also provides extension methods and properties to simplify working with these states.
/// It allows you to handle each state using the `when` and `whenMayNull` methods, and provides convenience methods
/// for checking the current state and extracting the value or error.
class StateAsync<T> {
  const factory StateAsync.loading() = AsyncLoadingC<T>;
  const factory StateAsync.initial() = AsyncInitial<T>;
  const factory StateAsync.data(T value) = AsyncDone<T>;
  const factory StateAsync.failure(Failure error) = AsyncFailure<T>;
}

/// Represents the initial state of an asynchronous operation.
class AsyncInitial<T> implements StateAsync<T> {
  const AsyncInitial();

  @override
  String toString() => 'AsyncInitial<${T.runtimeType}>';
}

/// Represents the loading state of an asynchronous operation.
class AsyncLoadingC<T> implements StateAsync<T> {
  const AsyncLoadingC();

  @override
  String toString() => 'AsyncLoadingC<${T.runtimeType}>';
}

/// Represents the successful completion of an asynchronous operation with a value.
class AsyncDone<T> implements StateAsync<T> {
  const AsyncDone(this.value);

  /// The value of the completed operation.
  final T value;

  @override
  String toString() => 'AsyncDone<$T>($value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// Represents the failure of an asynchronous operation with an error.
class AsyncFailure<T> implements StateAsync<T> {
  const AsyncFailure(this.error);

  /// The error that occurred during the operation.
  final Failure error;

  @override
  String toString() => 'AsyncFailure<$T>($error)';

  @override
  bool operator ==(covariant AsyncFailure<T> other) {
    if (identical(this, other)) return true;

    return other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

/// Extension methods for the [StateAsync] class.
extension AsyncExtension<T> on StateAsync<T> {
  /// Gets the error if the current state is [AsyncFailure], otherwise returns `null`.
  Failure? get error => (this is AsyncFailure) ? (this as AsyncFailure).error : null;

  /// Gets the value if the current state is [AsyncDone], otherwise returns `null`.
  T? get value => (this is AsyncDone<T>) ? (this as AsyncDone<T>).value : null;

  /// Checks if the current state is [AsyncLoadingC].
  bool get isLoading => this is AsyncLoadingC;

  /// Checks if the current state is [AsyncInitial].
  bool get isInitial => this is AsyncInitial;

  /// Checks if the current state is [AsyncDone].
  bool get isSuccess => this is AsyncDone<T>;

  /// Checks if the current state is [AsyncFailure].
  bool get isError => this is AsyncFailure;

  /// Handles each state of the [StateAsync] object and returns a value based on the state.
  ///
  /// The [when] method takes four functions as parameters:
  /// - [data]: Handles the [AsyncDone] state and passes the value to the function.
  /// - [error]: Handles the [AsyncFailure] state and passes the error to the function.
  /// - [loading]: Handles the [AsyncLoadingC] state.
  /// - [initial]: Handles the [AsyncInitial] state. If not provided, it defaults to the [loading] function.
  ///
  /// The method returns the value returned by the corresponding function based on the current state.
  ///
  /// Throws an exception if the current state is invalid.
  W when<W>({
    required W Function(T) data,
    required W Function(Failure) error,
    required W Function() loading,
    W Function()? initial,
  }) {
    if (this is AsyncLoadingC) {
      return loading();
    } else if (this is AsyncInitial) {
      return (initial ?? loading).call();
    } else if (this is AsyncDone<T>) {
      return data((this as AsyncDone<T>).value);
    } else if (this is AsyncFailure) {
      return error((this as AsyncFailure).error);
    } else {
      throw Exception('Invalid state');
    }
  }

  /// Handles each state of the [StateAsync] object and returns a value based on the state.
  ///
  /// The [whenMayNull] method takes four functions as parameters:
  /// - [data]: Handles the [AsyncDone] state and passes the value to the function.
  /// - [error]: Handles the [AsyncFailure] state and passes the error to the function.
  /// - [loading]: Handles the [AsyncLoadingC] state.
  /// - [initial]: Handles the [AsyncInitial] state.
  ///
  /// The method returns the value returned by the corresponding function based on the current state.
  ///
  /// Throws an exception if the current state is invalid.
  W whenMayNull<W>({
    required W Function(T?) data,
    required W Function(Failure) error,
    required W Function() loading,
    required W Function() initial,
  }) {
    if (this is AsyncLoadingC) {
      return loading();
    } else if (this is AsyncInitial) {
      return initial();
    } else if (this is AsyncDone<T>) {
      return data((this as AsyncDone<T>).value);
    } else if (this is AsyncFailure) {
      return error((this as AsyncFailure).error);
    } else {
      throw Exception('Invalid state');
    }
  }

  /// Handles the [AsyncDone] and [AsyncFailure] states of the [StateAsync] object and returns a widget based on the state.
  ///
  /// The [whenDataOrFailure] method takes two functions as parameters:
  /// - [failure]: Handles the [AsyncFailure] state and passes the error to the function.
  /// - [data]: Handles the [AsyncDone] state and passes the value to the function.
  ///
  /// The method returns the widget returned by the corresponding function based on the current state.
  ///
  /// Throws an exception if the current state is invalid.
  Widget whenDataOrFailure({
    required Widget Function(Failure failure) failure,
    required Widget Function(T data) data,
  }) {
    if (this is AsyncLoadingC) {
      return const Center(child: CircularProgressIndicator.adaptive());
    } else if (this is AsyncInitial) {
      return const Center(child: CircularProgressIndicator.adaptive());
    } else if (this is AsyncDone<T>) {
      return data((this as AsyncDone<T>).value);
    } else if (this is AsyncFailure) {
      return failure((this as AsyncFailure).error);
    } else {
      throw Exception('Invalid state');
    }
  }

  /// Handles the [AsyncDone], [AsyncFailure], and [AsyncInitial] states of the [StateAsync] object and returns a widget based on the state.
  ///
  /// The [whenOrNull] method takes four functions as parameters:
  /// - [data]: Handles the [AsyncDone] state and passes the value to the function.
  /// - [failure]: Handles the [AsyncFailure] state and passes the error to the function.
  /// - [loading]: Handles the [AsyncLoadingC] state. If not provided, it defaults to a circular progress indicator.
  /// - [initial]: Handles the [AsyncInitial] state. If not provided, it defaults to the [loading] function.
  ///
  /// The method returns the widget returned by the corresponding function based on the current state.
  ///
  /// Throws an exception if the current state is invalid.
  Widget whenOrNull({
    required Widget Function(T?) data,
    required Widget Function(Failure) failure,
    Widget Function()? loading,
    Widget Function()? initial,
  }) {
    if (this is AsyncLoadingC) {
      return loading?.call() ?? const CircularProgressIndicator.adaptive();
    } else if (this is AsyncInitial) {
      return initial?.call() ?? loading?.call() ?? const CircularProgressIndicator.adaptive();
    } else if (this is AsyncDone<T>) {
      return data((this as AsyncDone<T>).value);
    } else if (this is AsyncFailure) {
      return failure((this as AsyncFailure).error);
    } else {
      throw Exception('Invalid state');
    }
  }
}
