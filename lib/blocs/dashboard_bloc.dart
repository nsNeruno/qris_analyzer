import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qris_analyzer/blocs/src/base_state.dart';
import 'package:qris_analyzer/data/src/pref_storage.dart';
import 'package:qris_analyzer/models/cached_code.dart';

part 'src/events/dashboard.dart';
part 'src/states/dashboard.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {

  DashboardBloc(
    PrefListStorage<CachedCode> cacheRepository,
    PrefListStorage<CachedCode> favoriteRepository,
  )
      : _cacheRepository = cacheRepository,
        _favoriteRepository = favoriteRepository,
        super(const DashboardState._(),) {
    on<DashboardLoadHistories>(_onLoadHistories,);
    on<DashboardLoadFavorites>(_onLoadFavorites,);
    on<DashboardAddFavorite>(_onAddFavorite,);
  }

  FutureOr<void> _onLoadHistories(
    DashboardLoadHistories event, Emitter<DashboardState> emit,
  ) async {
    final codes = await _cacheRepository.readValues();
    emit(
      state._copyWith(
        recentCodes: codes,
      ),
    );
  }

  FutureOr<void> _onLoadFavorites(
    DashboardLoadFavorites event, Emitter<DashboardState> emit,
  ) async {
    final codes = await _favoriteRepository.readValues();
    emit(
      state._copyWith(
        favoriteCodes: codes,
      ),
    );
  }

  FutureOr<void> _onAddFavorite(
    DashboardAddFavorite event, Emitter<DashboardState> emit,
  ) async {
    await _favoriteRepository.add(event.code,);
    final newList = await _favoriteRepository.readValues();
    emit(
      state._copyWith(
        favoriteCodes: newList ?? [],
        transient: event.code,
      ),
    );
  }

  final PrefListStorage<CachedCode> _cacheRepository;
  final PrefListStorage<CachedCode> _favoriteRepository;
}