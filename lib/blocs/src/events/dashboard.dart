part of '../../dashboard_bloc.dart';

abstract class DashboardEvent {
  const DashboardEvent();
}

class DashboardReloadSavedCodes extends DashboardEvent {
  const DashboardReloadSavedCodes();
}

class DashboardLoadHistories extends DashboardEvent {
  const DashboardLoadHistories();
}

class DashboardLoadFavorites extends DashboardEvent {
  const DashboardLoadFavorites();
}

class DashboardAddFavorite extends DashboardEvent {

  const DashboardAddFavorite(this.code,);

  final CachedCode code;
}

class DashboardClearRecentEntries extends DashboardEvent {
  const DashboardClearRecentEntries();
}

class DashboardClearFavorites extends DashboardEvent {
  const DashboardClearFavorites();
}

class DashboardUpdateFavoriteName extends DashboardEvent {

  const DashboardUpdateFavoriteName({
    required this.code, required this.customName,
  });

  final CachedCode code;
  final String customName;
}