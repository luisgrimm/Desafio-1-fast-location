

part of 'home_controller.dart';



mixin _$HomeController on _HomeControllerBase, Store {
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError => (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
          name: '_HomeControllerBase.hasError'))
      .value;
  Computed<bool>? _$hasCurrentAddressComputed;

  @override
  bool get hasCurrentAddress =>
      (_$hasCurrentAddressComputed ??= Computed<bool>(
              () => super.hasCurrentAddress,
              name: '_HomeControllerBase.hasCurrentAddress'))
          .value;
  Computed<bool>? _$hasSearchResultsComputed;

  @override
  bool get hasSearchResults =>
      (_$hasSearchResultsComputed ??= Computed<bool>(
              () => super.hasSearchResults,
              name: '_HomeControllerBase.hasSearchResults'))
          .value;
  Computed<AddressModel?>? _$lastSearchedAddressComputed;

  @override
  AddressModel? get lastSearchedAddress =>
      (_$lastSearchedAddressComputed ??= Computed<AddressModel?>(
              () => super.lastSearchedAddress,
              name: '_HomeControllerBase.lastSearchedAddress'))
          .value;
  Computed<bool>? _$hasHistoryComputed;

  @override
  bool get hasHistory =>
      (_$hasHistoryComputed ??= Computed<bool>(() => super.hasHistory,
              name: '_HomeControllerBase.hasHistory'))
          .value;

  late final _$isLoadingAtom =
      Atom(name: '_HomeControllerBase.isLoading', context: context);

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
      Atom(name: '_HomeControllerBase.errorMessage', context: context);

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

  late final _$currentAddressAtom =
      Atom(name: '_HomeControllerBase.currentAddress', context: context);

  @override
  AddressModel? get currentAddress {
    _$currentAddressAtom.reportRead();
    return super.currentAddress;
  }

  @override
  set currentAddress(AddressModel? value) {
    _$currentAddressAtom.reportWrite(value, super.currentAddress, () {
      super.currentAddress = value;
    });
  }

  late final _$searchResultsAtom =
      Atom(name: '_HomeControllerBase.searchResults', context: context);

  @override
  List<AddressModel> get searchResults {
    _$searchResultsAtom.reportRead();
    return super.searchResults;
  }

  @override
  set searchResults(List<AddressModel> value) {
    _$searchResultsAtom.reportWrite(value, super.searchResults, () {
      super.searchResults = value;
    });
  }

  late final _$isSearchingMultipleAtom =
      Atom(name: '_HomeControllerBase.isSearchingMultiple', context: context);

  @override
  bool get isSearchingMultiple {
    _$isSearchingMultipleAtom.reportRead();
    return super.isSearchingMultiple;
  }

  @override
  set isSearchingMultiple(bool value) {
    _$isSearchingMultipleAtom.reportWrite(value, super.isSearchingMultiple, () {
      super.isSearchingMultiple = value;
    });
  }

  late final _$searchByCepAsyncAction =
      AsyncAction('_HomeControllerBase.searchByCep', context: context);

  @override
  Future<void> searchByCep(String cep) {
    return _$searchByCepAsyncAction.run(() => super.searchByCep(cep));
  }

  late final _$searchByAddressAsyncAction =
      AsyncAction('_HomeControllerBase.searchByAddress', context: context);

  @override
  Future<void> searchByAddress(
      {required String city, required String state, required String street}) {
    return _$searchByAddressAsyncAction.run(() => super
        .searchByAddress(city: city, state: state, street: street));
  }

  late final _$_HomeControllerBaseActionController =
      ActionController(name: '_HomeControllerBase', context: context);

  @override
  void selectAddressFromResults(AddressModel address) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.selectAddressFromResults');
    try {
      return super.selectAddressFromResults(address);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCurrentSearch() {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.clearCurrentSearch');
    try {
      return super.clearCurrentSearch();
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setLoading(bool loading) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase._setLoading');
    try {
      return super._setLoading(loading);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _clearError() {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase._clearError');
    try {
      return super._clearError();
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _clearSearchResults() {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase._clearSearchResults');
    try {
      return super._clearSearchResults();
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
errorMessage: ${errorMessage},
currentAddress: ${currentAddress},
searchResults: ${searchResults},
isSearchingMultiple: ${isSearchingMultiple},
hasError: ${hasError},
hasCurrentAddress: ${hasCurrentAddress},
hasSearchResults: ${hasSearchResults},
lastSearchedAddress: ${lastSearchedAddress},
hasHistory: ${hasHistory}
    ''';
  }
}