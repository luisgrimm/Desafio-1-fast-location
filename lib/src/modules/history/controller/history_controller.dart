import 'package:mobx/mobx.dart';
import 'package:fastlocation/src/modules/home/model/address_model.dart';
import 'package:fastlocation/src/modules/home/service/address_service.dart';

part 'history_controller.g.dart';

class HistoryController = _HistoryControllerBase with _$HistoryController;

abstract class _HistoryControllerBase with Store {
  final AddressService _addressService = AddressService();
  
  @observable
  List<AddressModel> addresses = [];
  
  @observable
  bool isLoading = false;
  
  @observable
  String? errorMessage;
  
  @computed
  bool get hasAddresses => addresses.isNotEmpty;
  
  @computed
  bool get hasError => errorMessage != null;
  
  @computed
  int get totalAddresses => addresses.length;
  
  @action
  Future<void> loadHistory() async {
    try {
      _setLoading(true);
      _clearError();
      
      addresses = _addressService.getHistory();
    } catch (e) {
      errorMessage = 'Erro ao carregar histórico: ${e.toString()}';
      addresses = [];
    } finally {
      _setLoading(false);
    }
  }
  
  @action
  Future<void> deleteAddress(AddressModel address) async {
    try {
      await _addressService.deleteFromHistory(address);
      addresses.removeWhere((item) => item.cep == address.cep);
    } catch (e) {
      errorMessage = 'Erro ao excluir endereço: ${e.toString()}';
    }
  }
  
  @action
  Future<void> clearHistory() async {
    try {
      await _addressService.clearHistory();
      addresses.clear();
    } catch (e) {
      errorMessage = 'Erro ao limpar histórico: ${e.toString()}';
    }
  }
  
  @action
  void _setLoading(bool loading) {
    isLoading = loading;
  }
  
  @action
  void _clearError() {
    errorMessage = null;
  }
  
  List<AddressModel> getAddressesGroupedByDate() {
    return List.from(addresses);
  }
  
  String formatDate(DateTime? date) {
    if (date == null) return 'Data não disponível';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final addressDate = DateTime(date.year, date.month, date.day);
    
    if (addressDate == today) {
      return 'Hoje às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (addressDate == yesterday) {
      return 'Ontem às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}