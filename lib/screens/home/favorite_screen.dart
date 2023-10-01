part of '../home_screen.dart';

class _FavoriteScreen extends StatelessWidget {

  const _FavoriteScreen();

  @override
  Widget build(BuildContext context) {

    return BlocSelector<DashboardBloc, DashboardState, List<CachedCode>>(
      selector: (state) => state.favoriteCodes,
      builder: (_, codes,) {
        if (codes.isEmpty) {
          return const Center(
            child: Text(
              'Currently no favorite codes yet',
              textAlign: TextAlign.center,
            ),
          );
        }

        final favoriteLookup = Map.fromEntries(
          codes.map((e) => MapEntry(e, true,),),
        );

        return ListView.separated(
          padding: const EdgeInsets.all(24,),
          itemBuilder: (_, i,) {
            final code = codes[i];
            return CodeEntry(
              code: code,
              favoriteLookup: favoriteLookup,
              onFavorite: (code) {
                if (favoriteLookup[code] ?? false) {
                  _confirmRemoveFromFavorite(context, code,);
                }
              },
              onEdit: (code) {
                _editCustomName(context, code,);
              },
            );
          },
          separatorBuilder: (_, __,) => const RSizedBox(height: 12,),
          itemCount: codes.length,
        );
      },
    );
  }

  void _confirmRemoveFromFavorite(BuildContext context, CachedCode code,) {
    showCustomModalBottomSheet<bool>(
      context: context,
      heightRatio: 0.2,
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Remove from Favorite?',),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(_,).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const RSizedBox(width: 8,),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(_,).pop(true,);
                    },
                    child: const Text('Remove',),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ).then(
      (shouldRemove) {
        if (shouldRemove ?? false) {
          context.read<DashboardBloc>().add(
            DashboardAddFavorite(code,),
          );
        }
      },
    );
  }

  void _editCustomName(BuildContext context, CachedCode code,) {
    late final controller = TextEditingController(
      text: code.customName ?? '',
    );
    showCustomModalBottomSheet<String>(
      context: context,
      heightRatio: 0.2,
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Custom Name',
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(_,).pop(controller.text.trim(),);
                },
                child: const Text('Save',),
              ),
            ),
          ],
        );
      },
    ).then(
      (_) {
        if (_?.isNotEmpty ?? false) {
          context.read<DashboardBloc>().add(
            DashboardUpdateFavoriteName(
              code: code, customName: _!,
            ),
          );
        }
      },
    );
  }
}