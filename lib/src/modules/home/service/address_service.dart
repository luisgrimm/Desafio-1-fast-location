import 'package:fastlocation/src/modules/home/model/address_model.dart';
import 'package:fastlocation/src/modules/home/repositories/address_repository.dart';
import 'package:fastlocation/src/modules/home/repositories/storage_repository.dart';

class AddressService {
  final AddressRepository _addressRepository = AddressRepository();
  final StorageRepository _storageRepository = StorageRepository();
  
  Future<AddressModel> searchByCep(String cep) async {
    final address = await _addressRepository.getAddressByCep(cep);
    await _storageRepository.saveAddress(address);
    return address;
  }
  
  Future<List<AddressModel>> searchByAddress({
    required String city,
    required String state,
    required String street,
  }) async {
    final addresses = await _addressRepository.getAddressByCity(city, state, street);
    
    // Salvar todos os endereços encontrados
    for (final address in addresses) {
      await _storageRepository.saveAddress(address);
    }
    
    return addresses;
  }
  
  List<AddressModel> getHistory() {
    return _storageRepository.getAllAddresses();
  }
  
  AddressModel? getLastSearchedAddress() {
    return _storageRepository.getLastAddress();
  }
  
  Future<void> deleteFromHistory(AddressModel address) async {
    await _storageRepository.deleteAddress(address);
  }
  
  Future<void> clearHistory() async {
    await _storageRepository.clearAllAddresses();
  }
  
  bool get hasHistory => _storageRepository.totalAddresses > 0;
  
  String formatCep(String cep) {
    final cleaned = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length == 8) {
      return '${cleaned.substring(0, 5)}-${cleaned.substring(5)}';
    }
    return cleaned;
  }
  
  bool isValidCep(String cep) {
    final cleaned = cep.replaceAll(RegExp(r'[^0-9]'), '');
    return cleaned.length == 8;
  }
}