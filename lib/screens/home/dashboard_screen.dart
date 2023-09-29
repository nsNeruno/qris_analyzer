part of '../home_screen.dart';

class _DashboardScreen extends StatelessWidget {

  const _DashboardScreen();

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        const RPadding(
          padding: EdgeInsets.all(24.0,),
          child: Text(
            'View Recent Scanned Codes, or Scan New Code',
          ),
        ),
        Expanded(
          child: BlocSelector<DashboardBloc, DashboardState, List<List<CachedCode>>>(
            selector: (state,) => [state.recentCodes, state.favoriteCodes,],
            builder: (_, codes,) {

              final recentCodes = codes[0];
              if (recentCodes.isEmpty) {
                return const Center(
                  child: Text(
                    'No recent codes, try scanning some codes',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final favorites = codes[1];
              final favoriteLookup = Map.fromEntries(
                favorites.map((e) => MapEntry(e, true,),),
              );

              return ListView.separated(
                padding: const EdgeInsets.all(24,),
                itemBuilder: (_, i,) {
                  final code = recentCodes[i];
                  return CodeEntry(
                    code: code,
                    favoriteLookup: favoriteLookup,
                    onFavorite: (code) {
                      _.read<DashboardBloc>().add(
                        DashboardAddFavorite(code,),
                      );
                    },
                  );
                },
                separatorBuilder: (_, __,) => const RSizedBox(height: 12,),
                itemCount: recentCodes.length,
              );
            },
          ),
        ),
      ],
    );
  }
}