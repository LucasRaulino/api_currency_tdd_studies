import 'package:app/src/model/currency.dart';
import 'package:app/src/repository/currency_repository.dart';

class MockCurrencyRepository extends CurrencyRepositoryBase {
  late List<Currency> _currencies;

  MockCurrencyRepository() {
    final timestamp = 500;
    final eur =
        Currency('EUR', 'Euro', 1, timestamp, isEnabled: true, position: 0);
    final usd =
        Currency('USD', 'USA', 1.17, timestamp, isEnabled: true, position: 0);
    _currencies = [eur, usd];
  }

  @override
  Stream<List<Currency>> getCurrencies() async* {
    yield _currencies;
  }
}
