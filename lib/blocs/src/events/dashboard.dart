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