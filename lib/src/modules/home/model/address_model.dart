import 'package:hive/hive.dart';

part 'address_model.g.dart';

@HiveType(typeId: 0)
class AddressModel extends HiveObject {
  @HiveField(0)
  String? cep;
  
  @HiveField(1)
  String? logradouro;
  
  @HiveField(2)
  String? complemento;
  
  @HiveField(3)
  String? bairro;
  
  @HiveField(4)
  String? localidade;
  
  @HiveField(5)
  String? uf;
  
  @HiveField(6)
  String? ibge;
  
  @HiveField(7)
  String? gia;
  
  @HiveField(8)
  String? ddd;
  
  @HiveField(9)
  String? siafi;
  
  @HiveField(10)
  DateTime? consultedAt;
  
  AddressModel({
    this.cep,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.localidade,
    this.uf,
    this.ibge,
    this.gia,
    this.ddd,
    this.siafi,
    this.consultedAt,
  });
  
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      cep: json['cep'],
      logradouro: json['logradouro'],
      complemento: json['complemento'],
      bairro: json['bairro'],
      localidade: json['localidade'],
      uf: json['uf'],
      ibge: json['ibge'],
      gia: json['gia'],
      ddd: json['ddd'],
      siafi: json['siafi'],
      consultedAt: DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'complemento': complemento,
      'bairro': bairro,
      'localidade': localidade,
      'uf': uf,
      'ibge': ibge,
      'gia': gia,
      'ddd': ddd,
      'siafi': siafi,
    };
  }
  
  String get fullAddress {
    final parts = <String>[];
    
    if (logradouro?.isNotEmpty == true) parts.add(logradouro!);
    if (bairro?.isNotEmpty == true) parts.add(bairro!);
    if (localidade?.isNotEmpty == true) parts.add(localidade!);
    if (uf?.isNotEmpty == true) parts.add(uf!);
    if (cep?.isNotEmpty == true) parts.add('CEP: $cep');
    
    return parts.join(', ');
  }
  
  bool get hasError => cep == null || logradouro == null;
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddressModel && other.cep == cep;
  }
  
  @override
  int get hashCode => cep.hashCode;
}