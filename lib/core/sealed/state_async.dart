import 'package:crypto_app/core/failure/failure.dart';
import 'package:flutter/material.dart';

sealed class StateAsync<T> {
  const factory StateAsync.loading() = AsyncLoadingC<T>;
  const factory StateAsync.initial() = AsyncInitial<T>;
  const factory StateAsync.data(T value) = AsyncDone<T>;
  const factory StateAsync.failure(Failure error) = AsyncFailure<T>;
}

class AsyncInitial<T> implements StateAsync<T> {
  const AsyncInitial();
  @override
  String toString() => 'AsyncInitial<${T.runtimeType}>';
}

class AsyncLoadingC<T> implements StateAsync<T> {
  const AsyncLoadingC();
  @override
  String toString() => 'AsyncLoadingC<${T.runtimeType}>';
}

class AsyncDone<T> implements StateAsync<T> {
  const AsyncDone(this.value);
  final T value;

  @override
  String toString() => 'AsyncDone<$T>($value)';
}

class AsyncFailure<T> implements StateAsync<T> {
  const AsyncFailure(this.error);
  final Failure error;

  @override
  String toString() => 'AsyncFailure<$T>($error)';
}

extension AsyncExtension<T> on StateAsync<T> {
  Failure? get error => (this is AsyncFailure) ? (this as AsyncFailure).error : null;
  T? get value => (this is AsyncDone<T>) ? (this as AsyncDone<T>).value : null;

  bool get isLoading => this is AsyncLoadingC;
  bool get isInitial => this is AsyncInitial;
  bool get isSuccess => this is AsyncDone<T>;
  bool get isError => this is AsyncFailure;

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
