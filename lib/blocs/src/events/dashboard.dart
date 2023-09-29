part of '../../dashboard_bloc.dart';

abstract class DashboardEvent {
  const DashboardEvent();
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