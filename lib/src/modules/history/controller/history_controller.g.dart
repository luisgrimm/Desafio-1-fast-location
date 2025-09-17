
part of 'history_controller.dart';



mixin _$HistoryController on _HistoryControllerBase, Store {
  Computed<bool>? _$hasAddressesComputed;

  @override
  bool get hasAddresses =>
      (_$hasAddressesComputed ??= Computed<bool>(() => super.hasAddresses,
              name: '_HistoryControllerBase.hasAddresses'))
          .value;
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError => (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
          name: '_HistoryControllerBase.hasError'))
      .value;
  Computed<int>? _$totalAddressesComputed;

  @override
  int get totalAddresses =>
      (_$totalAddressesComputed ??= Computed<int>(() => super.totalAddresses,
              name: '_HistoryControllerBase.totalAddresses'))
          .value;

  late final _$addressesAtom =
      Atom(name: '_HistoryControllerBase.addresses', context: context);

  @override
  List<AddressModel> get addresses {
    _$addressesAtom.reportRead();
    return super.addresses;
  }

  @override
  set addresses(List<AddressModel> value) {
    _$addressesAtom.reportWrite(value, super.addresses, () {
      super.addresses = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_HistoryControllerBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_HistoryControllerBase.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$loadHistoryAsyncAction =
      AsyncAction('_HistoryControllerBase.loadHistory', context: context);

  @override
  Future<void> loadHistory() {
    return _$loadHistoryAsyncAction.run(() => super.loadHistory());
  }

  late final _$deleteAddressAsyncAction =
      AsyncAction('_HistoryControllerBase.deleteAddress', context: context);

  @override
  Future<void> deleteAddress(AddressModel address) {
    return _$deleteAddressAsyncAction.run(() => super.deleteAddress(address));
  }

  late final _$clearHistoryAsyncAction =
      AsyncAction('_HistoryControllerBase.clearHistory', context: context);

  @override
  Future<void> clearHistory() {
    return _$clearHistoryAsyncAction.run(() => super.clearHistory());
  }

  late final _$_HistoryControllerBaseActionController =
      ActionController(name: '_HistoryControllerBase', context: context);

  @override
  void _setLoading(bool loading) {
    final _$actionInfo = _$_HistoryControllerBaseActionController.startAction(
        name: '_HistoryControllerBase._setLoading');
    try {
      return super._setLoading(loading);
    } finally {
      _$_HistoryControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _clearError() {
    final _$actionInfo = _$_HistoryControllerBaseActionController.startAction(
        name: '_HistoryControllerBase._clearError');
    try {
      return super._clearError();
    } finally {
      _$_HistoryControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
addresses: ${addresses},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
hasAddresses: ${hasAddresses},
hasError: ${hasError},
totalAddresses: ${totalAddresses}
    ''';
  }
}