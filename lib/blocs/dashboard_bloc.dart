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
    on<DashboardReloadSavedCodes>(_onReload,);
    on<DashboardLoadHistories>(_onLoadHistories,);
    on<DashboardLoadFavorites>(_onLoadFavorites,);
    on<DashboardAddFavorite>(_onAddFavorite,);
    on<DashboardClearRecentEntries>(_onClearRecentEntries,);
    on<DashboardClearFavorites>(_onClearFavorites,);
    on<DashboardUpdateFavoriteName>(_onNameUpdate,);
  }

  FutureOr<void> _onReload(
    DashboardReloadSavedCodes event, Emitter<DashboardState> emit,
  ) async {
    final codes = await Future.wait(
      [
        _cacheRepository.readValues(),
        _favoriteRepository.readValues(),
      ],
    );
    emit(
      state._copyWith(
        recentCodes: codes[0],
        favoriteCodes: codes[1],
      ),
    );
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

  FutureOr<void> _onClearRecentEntries(
    DashboardClearRecentEntries event, Emitter<DashboardState> emit,
  ) async {
    await _cacheRepository.removeAll();
    emit(
      state._copyWith(
        recentCodes: [],
      ),
    );
  }

  FutureOr<void> _onClearFavorites(
    DashboardClearFavorites event, Emitter<DashboardState> emit,
  ) async {
    await _favoriteRepository.removeAll();
    emit(
      state._copyWith(
        favoriteCodes: [],
      ),
    );
  }

  FutureOr<void> _onNameUpdate(
    DashboardUpdateFavoriteName event, Emitter<DashboardState> emit,
  ) async {
    final removed = await _favoriteRepository.remove(event.code,);
    if (removed != null) {
      _favoriteRepository.add(
        removed.copyWith(customName: event.customName,),
      );
      final favoriteCodes = await _favoriteRepository.readValues();
      emit(
        state._copyWith(
          favoriteCodes: favoriteCodes,
        ),
      );
    }
  }

  final PrefListStorage<CachedCode> _cacheRepository;
  final PrefListStorage<CachedCode> _favoriteRepository;

}