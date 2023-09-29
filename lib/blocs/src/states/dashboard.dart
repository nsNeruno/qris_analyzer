part of '../../dashboard_bloc.dart';

class DashboardState extends BlocState {

  const DashboardState._({
    this.recentCodes = const [],
    this.favoriteCodes = const [],
    super.isLoading,
    super.error,
    super.tag,
    super.transient,
  });

  DashboardState _copyWith({
    List<CachedCode>? recentCodes,
    List<CachedCode>? favoriteCodes,
    bool isLoading = false,
    Object? error,
    Object? tag,
    Object? transient,
  }) {
    return DashboardState._(
      recentCodes: recentCodes ?? this.recentCodes,
      favoriteCodes: favoriteCodes ?? this.favoriteCodes,
      isLoading: isLoading,
      error: error,
      tag: tag,
      transient: transient,
    );
  }

  final List<CachedCode> recentCodes;
  final List<CachedCode> favoriteCodes;
}