import 'package:mobx/mobx.dart';
import 'package:fastlocation/src/modules/home/model/address_model.dart';
import 'package:fastlocation/src/modules/home/service/address_service.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final AddressService _addressService = AddressService();
  
  @observable
  bool isLoading = false;
  
  @observable
  String? errorMessage;
  
  @observable
  AddressModel? currentAddress;
  
  @observable
  List<AddressModel> searchResults = [];
  
  @observable
  bool isSearchingMultiple = false;
  
  @computed
  bool get hasError => errorMessage != null;
  
  @computed
  bool get hasCurrentAddress => currentAddress != null;
  
  @computed
  bool get hasSearchResults => searchResults.isNotEmpty;
  
  @computed
  AddressModel? get lastSearchedAddress => _addressService.getLastSearchedAddress();
  
  @computed
  bool get hasHistory => _addressService.hasHistory;
  
  @action
  Future<void> searchByCep(String cep) async {
    if (cep.trim().isEmpty) {
      errorMessage = 'Por favor, digite um CEP';
      return;
    }
    
    if (!_addressService.isValidCep(cep)) {
      errorMessage = 'CEP deve conter 8 dígitos';
      return;
    }
    
    try {
      _setLoading(true);
      _clearError();
      _clearSearchResults();
      
      currentAddress = await _addressService.searchByCep(cep);
    } catch (e) {
      errorMessage = e.toString();
      currentAddress = null;
    } finally {
      _setLoading(false);
    }
  }
  
  @action
  Future<void> searchByAddress({
    required String city,
    required String state,
    required String street,
  }) async {
    if (city.trim().isEmpty || state.trim().isEmpty || street.trim().isEmpty) {
      errorMessage = 'Por favor, preencha cidade, estado e logradouro';
      return;
    }
    
    try {
      _setLoading(true);
      _clearError();
      currentAddress = null;
      isSearchingMultiple = true;
      
      searchResults = await _addressService.searchByAddress(
        city: city.trim(),
        state: state.trim(),
        street: street.trim(),
      );
    } catch (e) {
      errorMessage = e.toString();
      searchResults = [];
    } finally {
      _setLoading(false);
      isSearchingMultiple = false;
    }
  }
  
  @action
  void selectAddressFromResults(AddressModel address) {
    currentAddress = address;
    _clearSearchResults();
  }
  
  @action
  void clearCurrentSearch() {
    currentAddress = null;
    _clearSearchResults();
    _clearError();
  }
  
  @action
  void _setLoading(bool loading) {
    isLoading = loading;
  }
  
  @action
  void _clearError() {
    errorMessage = null;
  }
  
  @action
  void _clearSearchResults() {
    searchResults = [];
    isSearchingMultiple = false;
  }
  
  String formatCep(String cep) {
    return _addressService.formatCep(cep);
  }
}