import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:observatory/deals/deals_provider.dart';
import 'package:observatory/deals/deals_state.dart';
import 'package:observatory/settings/settings_repository.dart';
import 'package:observatory/shared/models/deal.dart';
import 'package:observatory/shared/models/price.dart';
import 'package:observatory/shared/models/shop.dart';

final List<Deal> deals = [
  const Deal(
    id: '018d937f-505a-7386-b1c4-42986a89ec79',
    title: 'GNOSIA',
    type: 'game',
    slug: 'gnosia',
    prices: [
      Price(
        cut: 0.0,
        drm: [
          DRM(id: 1, name: 'Steam'),
        ],
        price: PriceDetails(
          amount: 24.99,
          amountInt: 24,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 24.99,
          amountInt: 24,
          currency: 'USD',
        ),
        shop: Shop(id: 63, name: 'Steam'),
      ),
    ],
  ),
  const Deal(
    id: '018d937f-506e-72eb-975a-1a5175b622de',
    title: 'Lies Of P',
    type: 'game',
    slug: 'lies-of-p',
    prices: [
      Price(
        cut: 30.0,
        drm: [
          DRM(id: 1, name: 'Steam'),
        ],
        price: PriceDetails(
          amount: 41.99,
          amountInt: 41,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 41.99,
          amountInt: 41,
          currency: 'USD',
        ),
        shop: Shop(id: 63, name: 'Steam'),
      ),
      Price(
        cut: 17.0,
        drm: [
          DRM(id: 2, name: 'Steam'),
        ],
        voucher: 'OMEN17',
        price: PriceDetails(
          amount: 49.79,
          amountInt: 49,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 49.79,
          amountInt: 49,
          currency: 'USD',
        ),
        shop: Shop(id: 63, name: 'Fanatical'),
      ),
      Price(
        cut: 0.0,
        drm: [
          DRM(id: 3, name: 'Microsoft Store'),
        ],
        price: PriceDetails(
          amount: 59.99,
          amountInt: 59,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 59.99,
          amountInt: 59,
          currency: 'USD',
        ),
        shop: Shop(id: 63, name: 'Microsoft Store'),
      ),
      Price(
        cut: 0.0,
        drm: [
          DRM(id: 3, name: 'Steam'),
        ],
        price: PriceDetails(
          amount: 59.99,
          amountInt: 59,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 59.99,
          amountInt: 59,
          currency: 'USD',
        ),
        shop: Shop(id: 66, name: 'Humble Store'),
      ),
      Price(
        cut: 0.0,
        drm: [
          DRM(id: 3, name: 'Steam'),
        ],
        price: PriceDetails(
          amount: 59.99,
          amountInt: 59,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 59.99,
          amountInt: 59,
          currency: 'USD',
        ),
        shop: Shop(id: 67, name: 'GreenManGaming'),
      ),
    ],
  ),
  const Deal(
    id: '018d937f-1ea1-732d-ab65-d3fc078354b3',
    title: 'Danganronpa 2: Goodbye Despair',
    type: 'game',
    slug: 'danganronpa-2-goodbye-despair',
    prices: [
      Price(
        cut: 0.0,
        drm: [
          DRM(id: 3, name: 'Steam'),
        ],
        price: PriceDetails(
          amount: 19.99,
          amountInt: 19,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 19.99,
          amountInt: 19,
          currency: 'USD',
        ),
        shop: Shop(id: 66, name: 'Humble Store'),
      ),
      Price(
        cut: 0.0,
        drm: [
          DRM(id: 3, name: 'Steam'),
        ],
        price: PriceDetails(
          amount: 19.99,
          amountInt: 19,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 19.99,
          amountInt: 19,
          currency: 'USD',
        ),
        shop: Shop(id: 1, name: 'Steam'),
      ),
    ],
  ),
  const Deal(
    id: '018d937f-74ed-71be-8f12-bca1cf5eabe6',
    title: 'Little Goody Two Shoes',
    type: 'game',
    slug: 'little-goody-two-shoes',
    prices: [
      Price(
        cut: 20.0,
        drm: [
          DRM(id: 3, name: 'Steam'),
        ],
        price: PriceDetails(
          amount: 15.99,
          amountInt: 15,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 15.99,
          amountInt: 15,
          currency: 'USD',
        ),
        shop: Shop(id: 66, name: 'GreenManGaming'),
      ),
      Price(
        cut: 20.0,
        drm: [
          DRM(id: 3, name: 'Steam'),
        ],
        price: PriceDetails(
          amount: 15.99,
          amountInt: 15,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 15.99,
          amountInt: 15,
          currency: 'USD',
        ),
        shop: Shop(id: 1, name: 'Humble Store'),
      ),
      Price(
        cut: 11.0,
        drm: [
          DRM(id: 3, name: 'Steam'),
        ],
        price: PriceDetails(
          amount: 17.88,
          amountInt: 17,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 17.88,
          amountInt: 17,
          currency: 'USD',
        ),
        shop: Shop(id: 1, name: 'IndieGala Store'),
      ),
      Price(
        cut: 0.0,
        drm: [
          DRM(id: 3, name: 'Steam'),
        ],
        price: PriceDetails(
          amount: 19.99,
          amountInt: 19,
          currency: 'USD',
        ),
        regular: PriceDetails(
          amount: 19.99,
          amountInt: 19,
          currency: 'USD',
        ),
        shop: Shop(id: 1, name: 'Steam'),
      ),
    ],
  )
];

class AsyncDealsNotifierMock
    extends AutoDisposeFamilyAsyncNotifier<DealsState, DealCategory>
    with Mock
    implements AsyncDealsNotifier {
  Future<DealsState> _initDeals() async {
    return DealsState(
      deals: deals,
      hasReachedMax: false,
      pageNumber: 1,
    );
  }

  @override
  Future<DealsState> build(DealCategory arg) async {
    return _initDeals();
  }

  @override
  Future<void> fetchMore() async {
    state = state;
  }

  @override
  Future<List<Deal>> fetchDeals({int offset = 0}) async {
    return deals;
  }

  @override
  Future<void> reset() async {
    state = state;
  }
}
