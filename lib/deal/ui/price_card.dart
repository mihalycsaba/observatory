import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observatory/deal/ui/current_price.dart';
import 'package:observatory/deal/ui/price_bottom_sheet.dart';
import 'package:observatory/deal/ui/price_cut.dart';
import 'package:observatory/deal/ui/voucher_list_tile.dart';
import 'package:observatory/shared/models/price.dart';
import 'package:observatory/shared/ui/observatory_card.dart';
import 'package:url_launcher/url_launcher.dart';

class PriceCard extends StatelessWidget {
  final bool hasBottomSheet;

  const PriceCard({
    super.key,
    required this.price,
    this.hasBottomSheet = true,
  });

  final Price price;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.colors.scheme.primaryContainer,
      splashFactory: InkSparkle.splashFactory,
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
      onTap: () {
        launchUrl(
          Uri.parse(price.url),
          mode: LaunchMode.externalApplication,
        );
      },
      onLongPress: hasBottomSheet
          ? () {
              HapticFeedback.mediumImpact();

              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                builder: (BuildContext context) {
                  return PriceBottomSheet(price: price);
                },
              );
            }
          : null,
      child: ObservatoryCard(
        child: Column(
          children: [
            ListTile(
              leading: SizedBox(
                width: 60,
                child: Center(
                  child: PriceCut(
                    priceCut: price.cut,
                  ),
                ),
              ),
              title: Text(price.shop.name),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'DRM: ',
                          style: context.themes.text.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colors.scheme.onSurfaceVariant,
                          ),
                        ),
                        TextSpan(
                          text: price.formattedDRM,
                          style: context.themes.text.labelSmall?.copyWith(
                            color: context.colors.scheme.onSurfaceVariant,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
              trailing: CurrentPrice(price: price),
            ),
            if (price.voucher != null && price.voucher != '')
              VoucherListTile(price: price),
          ],
        ),
      ),
    );
  }
}
