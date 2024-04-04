import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:observatory/deal/ui/deal_card.dart';
import 'package:observatory/search/search_provider.dart';
import 'package:observatory/search/search_state.dart';
import 'package:observatory/settings/settings_provider.dart';
import 'package:observatory/settings/settings_repository.dart';
import 'package:observatory/shared/models/deal.dart';
import 'package:observatory/shared/widgets/error_message.dart';
import 'package:observatory/shared/widgets/progress_indicator.dart';
import 'package:observatory/waitlist/waitlist_provider.dart';
import 'package:observatory/waitlist/waitlist_state.dart';

class WaitListList extends ConsumerWidget {
  const WaitListList({super.key});

  List<Deal> getSortedWaitlist(
    List<Deal> deals,
    WaitlistSorting sorting,
    WaitlistSortingDirection sortingDirection,
  ) {
    final num detractor =
        sortingDirection == WaitlistSortingDirection.asc ? -1 : double.infinity;

    switch (sorting) {
      case WaitlistSorting.date_added:
        return [...deals]..sort(
            (a, b) {
              if (sortingDirection == WaitlistSortingDirection.desc) {
                return (a.added).compareTo(b.added);
              }

              return (b.added).compareTo(a.added);
            },
          );

      case WaitlistSorting.price:
        return [...deals]..sort(
            (a, b) {
              if (sortingDirection == WaitlistSortingDirection.asc) {
                return (b.prices?.firstOrNull?.price.amount ?? detractor)
                    .compareTo(
                        a.prices?.firstOrNull?.price.amount ?? detractor);
              }

              return (a.prices?.firstOrNull?.price.amount ?? detractor)
                  .compareTo(b.prices?.firstOrNull?.price.amount ?? detractor);
            },
          );
      case WaitlistSorting.price_cut:
        return [...deals]..sort(
            (a, b) {
              if (sortingDirection == WaitlistSortingDirection.desc) {
                return (a.prices?.firstOrNull?.cut ?? detractor)
                    .compareTo(b.prices?.firstOrNull?.cut ?? detractor);
              }

              return (b.prices?.firstOrNull?.cut ?? detractor)
                  .compareTo(a.prices?.firstOrNull?.cut ?? detractor);
            },
          );

      case WaitlistSorting.title:
        return [...deals]..sort(
            (a, b) {
              if (sortingDirection == WaitlistSortingDirection.desc) {
                return (b.title).compareTo(a.title);
              }

              return (a.title).compareTo(b.title);
            },
          );

      default:
        return deals;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SearchState searchState = ref.watch(filterResultsProvider);
    final AsyncValue<WaitListState> waitlist = ref.watch(asyncWaitListProvider);
    final WaitlistSortingDirection sortingDirection = ref.watch(
      asyncSettingsProvider.select(
        (value) => value.requireValue.waitlistSortingDirection,
      ),
    );
    final WaitlistSorting sorting = ref.watch(
      asyncSettingsProvider.select(
        (value) => value.requireValue.waitlistSorting,
      ),
    );

    return waitlist.when(
      loading: () {
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: ObservatoryProgressIndicator(),
          ),
        );
      },
      error: (error, stackTrace) {
        Logger().e(
          'Failed to fetch waitlist',
          error: error,
          stackTrace: stackTrace,
        );

        FirebaseCrashlytics.instance.recordError(
          error,
          stackTrace,
        );

        return SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: ErrorMessage(
              message: 'Failed to fetch waitlist',
              helper: TextButton(
                child: const Text('Refresh'),
                onPressed: () async {
                  return ref.watch(asyncWaitListProvider.notifier).reset();
                },
              ),
            ),
          ),
        );
      },
      data: (data) {
        if (data.deals.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: ErrorMessage(
                message:
                    'Your waitlist is empty. You can add games from the Deals or Search tabs.',
                icon: Icons.heart_broken,
              ),
            ),
          );
        }

        if (searchState.isOpen && searchState.query != null) {
          final List<Deal> foundGames = data.deals
              .where(
                (deal) => deal.title.toLowerCase().contains(
                      searchState.query!.toLowerCase(),
                    ),
              )
              .toList();

          if (foundGames.isEmpty) {
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: ErrorMessage(
                  message: 'No games found',
                  icon: Icons.sentiment_dissatisfied_rounded,
                ),
              ),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.all(6.0),
            sliver: SliverList.builder(
              itemBuilder: (context, index) {
                return DealCard(
                  deal: foundGames[index],
                );
              },
              itemCount: foundGames.length,
            ),
          );
        }

        final List<Deal> sortedWaitlist = getSortedWaitlist(
          data.deals,
          sorting,
          sortingDirection,
        );

        return SliverPadding(
          padding: const EdgeInsets.all(6.0),
          sliver: SliverList.builder(
            itemBuilder: (context, index) {
              return DealCard(
                deal: sortedWaitlist[index],
              );
            },
            itemCount: sortedWaitlist.length,
          ),
        );
      },
    );
  }
}