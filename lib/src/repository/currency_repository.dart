import 'package:app/src/model/currency.dart';

abstract class CurrencyRepositoryBase {
  Stream<List<Currency>> getCurrencies();
}
