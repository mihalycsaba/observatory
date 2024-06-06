import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:observatory/deal/ui/page_sections/search_on_tile.dart';
import 'package:observatory/shared/models/deal.dart';

class LinksTile extends StatelessWidget {
  final Deal deal;

  const LinksTile({
    super.key,
    required this.deal,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      key: Key('links-tile-${deal.id}'),
      dense: true,
      child: ExpansionTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Text(
            'Links',
            style: context.themes.text.labelLarge?.copyWith(
              color: context.colors.hint,
            ),
          ),
        ),
        subtitle: Text(
          'Steam, Metacritic, YouTube, etc.',
          style: context.themes.text.labelLarge?.copyWith(
            color: context.colors.scheme.onSurface,
          ),
        ),
        children: [
          Builder(
            builder: (context) {
              final Uri? uri = Uri.tryParse(deal.steamPrice?.url ?? '');

              if (uri != null) {
                return SearchOnTile(
                  deal: deal,
                  title: 'Open on Steam',
                  leading: FontAwesomeIcons.steam,
                  link: uri,
                );
              }

              return SearchOnTile(
                deal: deal,
                title: 'Search on Steam',
                leading: FontAwesomeIcons.steam,
                link: Uri.parse(
                  'https://store.steampowered.com/search/?term=${Uri.encodeQueryComponent(deal.title)}',
                ),
              );
            },
          ),
          SearchOnTile(
            deal: deal,
            title: 'Search on YouTube',
            leading: FontAwesomeIcons.youtube,
            link: Uri.parse(
              'https://www.youtube.com/results?search_query=${Uri.encodeQueryComponent(deal.title)}',
            ),
          ),
          SearchOnTile(
            deal: deal,
            title: 'Search on Wikipedia',
            leading: FontAwesomeIcons.wikipediaW,
            link: Uri.parse(
              'https://en.wikipedia.org/w/index.php?search=${Uri.encodeComponent(deal.title)}',
            ),
          ),
          SearchOnTile(
            deal: deal,
            title: 'Search on Metacritic',
            leading: FontAwesomeIcons.squareArrowUpRight,
            link: Uri.parse(
              'https://www.metacritic.com/search/${Uri.encodeComponent(deal.title)}/',
            ),
          ),
        ],
      ),
    );
  }
}