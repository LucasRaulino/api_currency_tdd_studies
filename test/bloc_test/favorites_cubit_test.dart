import 'package:app/src/bloc/favorites_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mock_currency_repository.dart';

void main() {
  late MockCurrencyRepository currencyRepository;

  setUp(() {
    currencyRepository = MockCurrencyRepository();
  });

  blocTest<FavoritesCubit, FavoriteState>(
    'Favorites cubit initialized correctly',
    build: () => FavoritesCubit(currencyRepository),
    verify: (cubit) {
      expect(cubit.state is FavoriteReadyState, true);
      final state = cubit.state as FavoriteReadyState;
      expect(state.currencies.length, 2);
      expect(state.currencies[0].key, 'EUR');
    },
  );
}
