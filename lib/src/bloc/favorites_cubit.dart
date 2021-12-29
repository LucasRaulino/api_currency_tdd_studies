import 'dart:async';

import 'package:app/src/extensions/string_extension.dart';
import 'package:app/src/model/currency.dart';
import 'package:app/src/repository/currency_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<FavoriteState> {
  final CurrencyRepositoryBase _repository;
  late final StreamSubscription subscription;
  List<Currency> _currencies = [];

  String filter = '';

  FavoritesCubit(this._repository) : super(FavoriteLoadingState()) {
    _init();
  }

  Future<void> _init() async {
    subscription = _repository.getCurrencies().listen((e) {
      if (e.isNotEmpty) {
        _currencies = e;
        _updateState();
      }
    });
  }

  void filterCurrencies(String filter) {
    this.filter = filter;
    _updateState();
  }

  void _updateState() {
    if (filter.isEmpty) {
      emit(FavoriteReadyState(_currencies));
    } else {
      final result = _currencies.where((e) {
        return e.key.containsIgnoreCase(filter) ||
            e.name.toLowerCase().contains(filter.toLowerCase());
      }).toList();
      emit(FavoriteReadyState(result));
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}

class FavoriteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriteLoadingState extends FavoriteState {}

class FavoriteReadyState extends FavoriteState {
  final List<Currency> currencies;

  FavoriteReadyState(this.currencies);

  @override
  List<Object?> get props => [currencies];
}
