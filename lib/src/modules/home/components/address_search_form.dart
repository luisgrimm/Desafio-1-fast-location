import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fastlocation/src/shared/colors/app_colors.dart';
import 'package:fastlocation/src/shared/metrics/app_metrics.dart';

class AddressSearchForm extends StatefulWidget {
  final Function(String) onCepSearch;
  final Function(String city, String state, String street) onAddressSearch;
  final bool isLoading;
  
  const AddressSearchForm({
    super.key,
    required this.onCepSearch,
    required this.onAddressSearch,
    this.isLoading = false,
  });

  @override
  State<AddressSearchForm> createState() => _AddressSearchFormState();
}

class _AddressSearchFormState extends State<AddressSearchForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _cepController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _streetController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _cepController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(AppMetrics.marginMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppMetrics.paddingMedium),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.grey,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(text: 'Buscar por CEP'),
                Tab(text: 'Buscar Endereço'),
              ],
            ),
            const SizedBox(height: AppMetrics.marginMedium),
            SizedBox(
              height: 200,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCepSearch(),
                  _buildAddressSearch(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCepSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _cepController,
          decoration: const InputDecoration(
            labelText: 'CEP',
            hintText: 'Digite o CEP (ex: 01234-567)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(9), // 8 digits + 1 hyphen
            CepInputFormatter(),
          ],
          enabled: !widget.isLoading,
        ),
        const SizedBox(height: AppMetrics.marginMedium),
        ElevatedButton.icon(
          onPressed: widget.isLoading ? null : () {
            widget.onCepSearch(_cepController.text);
          },
          icon: widget.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.search),
          label: Text(widget.isLoading ? 'Buscando...' : 'Buscar CEP'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            minimumSize: const Size.fromHeight(AppMetrics.buttonHeight),
          ),
        ),
      ],
    );
  }
  
  Widget _buildAddressSearch() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
                enabled: !widget.isLoading,
              ),
            ),
            const SizedBox(width: AppMetrics.marginSmall),
            Expanded(
              child: TextField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'UF',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2),
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                ],
                enabled: !widget.isLoading,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppMetrics.marginSmall),
        TextField(
          controller: _streetController,
          decoration: const InputDecoration(
            labelText: 'Logradouro',
            hintText: 'Rua, Avenida, etc.',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.streetview),
          ),
          enabled: !widget.isLoading,
        ),
        const SizedBox(height: AppMetrics.marginMedium),
        ElevatedButton.icon(
          onPressed: widget.isLoading ? null : () {
            widget.onAddressSearch(
              _cityController.text,
              _stateController.text,
              _streetController.text,
            );
          },
          icon: widget.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.search),
          label: Text(widget.isLoading ? 'Buscando...' : 'Buscar Endereço'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            minimumSize: const Size.fromHeight(AppMetrics.buttonHeight),
          ),
        ),
      ],
    );
  }
}

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll('-', '');
    String oldText = oldValue.text.replaceAll('-', '');

    if (newText.length > oldText.length) {
      if (newText.length > 8) {
        return oldValue;
      }
      if (newText.length > 5) {
        newText = '${newText.substring(0, 5)}-${newText.substring(5)}';
      }
    } else if (newText.length < oldText.length) {
      if (oldValue.text.length == 7 && oldValue.text.endsWith('-')) {
        return TextEditingValue(
          text: oldValue.text.substring(0, oldValue.text.length - 1),
          selection: TextSelection.collapsed(offset: oldValue.text.length - 1),
        );
      }
    }
    
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}