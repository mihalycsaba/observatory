import 'package:collection/collection.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:observatory/settings/settings_provider.dart';
import 'package:observatory/settings/ui/scheme_preview.dart';

class ThemeListTile extends ConsumerWidget {
  const ThemeListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? selectedScheme = ref.watch(
      themesProvider.select((state) => state.scheme),
    );
    final FlexScheme selectedFlexScheme = FlexScheme.values.firstWhereOrNull(
          (FlexScheme scheme) => scheme.name == selectedScheme,
        ) ??
        FlexScheme.mandyRed;
    final List<FlexScheme> schemes = List.from(FlexScheme.values)
      ..insert(0, selectedFlexScheme);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ListTile(
          title: const Text('Color Scheme'),
          subtitle: const Text('Select color scheme.'),
          trailing: OutlinedButton.icon(
            onPressed: () {
              ref.read(themesProvider.notifier).setScheme(FlexScheme.mandyRed);
            },
            icon: const Icon(Icons.restore_rounded),
            label: const Text('Reset'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SizedBox(
            height: 70,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: schemes.length,
              itemBuilder: (context, index) {
                return SchemePreview(
                  scheme: schemes[index],
                );
              },
            ),
          ),
        )
      ],
    );
  }
}