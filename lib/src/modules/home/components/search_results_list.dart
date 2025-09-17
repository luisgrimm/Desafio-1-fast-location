import 'package:flutter/material.dart';
import 'package:fastlocation/src/modules/home/model/address_model.dart';
import 'package:fastlocation/src/modules/home/components/address_result_card.dart';
import 'package:fastlocation/src/shared/metrics/app_metrics.dart';

class SearchResultsList extends StatelessWidget {
  final List<AddressModel> addresses;
  final Function(AddressModel) onAddressSelected;
  
  const SearchResultsList({
    super.key,
    required this.addresses,
    required this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppMetrics.paddingMedium,
          ),
          child: Text(
            'Encontrados ${addresses.length} resultado${addresses.length != 1 ? 's' : ''}:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: AppMetrics.marginSmall),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: addresses.length,
          itemBuilder: (context, index) {
            final address = addresses[index];
            return AddressResultCard(
              address: address,
              onTap: () => onAddressSelected(address),
            );
          },
        ),
      ],
    );
  }
}