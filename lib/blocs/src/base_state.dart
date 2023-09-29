abstract class BlocState {

  const BlocState({
    this.isLoading = false,
    this.transient,
    this.tag,
    this.error,
  });

  final bool isLoading;
  final Object? transient;
  final Object? tag;
  final Object? error;
}