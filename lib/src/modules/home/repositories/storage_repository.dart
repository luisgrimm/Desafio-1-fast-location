import 'package:fastlocation/src/shared/storage/storage_config.dart';
import 'package:fastlocation/src/modules/home/model/address_model.dart';

class StorageRepository {
  Future<void> saveAddress(AddressModel address) async {
    if (StorageConfig.useInMemory) {
      final list = StorageConfig.memoryAddresses;
      final existingIndex = list.indexWhere((item) => item.cep == address.cep);
      if (existingIndex != -1) {
        list[existingIndex] = address;
      } else {
        list.add(address);
      }
      return;
    }

    final box = StorageConfig.addressBox;

  
    final existingIndex = box.values
        .toList()
        .indexWhere((item) => item.cep == address.cep);

    if (existingIndex != -1) {
      
      final existingKey = box.keyAt(existingIndex);
      await box.put(existingKey, address);
    } else {
      
      await box.add(address);
    }
  }

  List<AddressModel> getAllAddresses() {
    final List<AddressModel> addresses;
    if (StorageConfig.useInMemory) {
      addresses = List<AddressModel>.from(StorageConfig.memoryAddresses);
    } else {
      final box = StorageConfig.addressBox;
      addresses = box.values.toList();
    }

    
    addresses.sort((a, b) {
      if (a.consultedAt == null && b.consultedAt == null) return 0;
      if (a.consultedAt == null) return 1;
      if (b.consultedAt == null) return -1;
      return b.consultedAt!.compareTo(a.consultedAt!);
    });

    return addresses;
  }

  AddressModel? getLastAddress() {
    final addresses = getAllAddresses();
    return addresses.isNotEmpty ? addresses.first : null;
  }

  Future<void> deleteAddress(AddressModel address) async {
    if (StorageConfig.useInMemory) {
      StorageConfig.memoryAddresses
          .removeWhere((item) => item.cep == address.cep);
      return;
    }

    final box = StorageConfig.addressBox;
    final index = box.values
        .toList()
        .indexWhere((item) => item.cep == address.cep);

    if (index != -1) {
      final key = box.keyAt(index);
      await box.delete(key);
    }
  }

  Future<void> clearAllAddresses() async {
    if (StorageConfig.useInMemory) {
      StorageConfig.memoryAddresses.clear();
      return;
    }

    final box = StorageConfig.addressBox;
    await box.clear();
  }

  int get totalAddresses =>
      StorageConfig.useInMemory
          ? StorageConfig.memoryAddresses.length
          : StorageConfig.addressBox.length;
}
