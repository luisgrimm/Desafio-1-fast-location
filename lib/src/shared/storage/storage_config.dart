import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fastlocation/src/modules/home/model/address_model.dart';

class StorageConfig {

  static bool useInMemory = false;
  static final List<AddressModel> _memoryAddresses = <AddressModel>[];

  static List<AddressModel> get memoryAddresses => _memoryAddresses;

  static Future<void> init() async {
    if (kIsWeb) {

      useInMemory = true;

      print('[StorageConfig] Web detected: using in-memory storage.');
      return;
    }

    await Hive.initFlutter();

  
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(AddressModelAdapter());
    }


    print('[StorageConfig] Mobile/desktop detected: opening Hive box.');
    await Hive.openBox<AddressModel>('addresses');
  }

  static Box<AddressModel> get addressBox => Hive.box<AddressModel>('addresses');

  static Future<void> dispose() async {
    if (useInMemory) return;
    await Hive.close();
  }
}