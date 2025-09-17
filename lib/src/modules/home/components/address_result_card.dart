import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fastlocation/src/modules/home/model/address_model.dart';
import 'package:fastlocation/src/shared/colors/app_colors.dart';
import 'package:fastlocation/src/shared/metrics/app_metrics.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';

class AddressResultCard extends StatelessWidget {
  final AddressModel address;
  final bool isLastSearched;
  final VoidCallback? onTap;
  
  const AddressResultCard({
    super.key,
    required this.address,
    this.isLastSearched = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppMetrics.marginMedium,
        vertical: AppMetrics.marginSmall,
      ),
      elevation: isLastSearched ? 4 : 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppMetrics.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppMetrics.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLastSearched)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppMetrics.paddingSmall,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'ÚLTIMA CONSULTA',
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (isLastSearched) const SizedBox(height: AppMetrics.marginSmall),
              
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                    size: AppMetrics.iconMedium,
                  ),
                  const SizedBox(width: AppMetrics.marginSmall),
                  Expanded(
                    child: Text(
                      'CEP: ${address.cep ?? 'N/A'}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppMetrics.marginSmall),
              
              if (address.logradouro?.isNotEmpty == true)
                _buildAddressRow(
                  context,
                  Icons.streetview,
                  'Logradouro',
                  address.logradouro!,
                ),
              
              if (address.bairro?.isNotEmpty == true)
                _buildAddressRow(
                  context,
                  Icons.location_city,
                  'Bairro',
                  address.bairro!,
                ),
              
              if (address.localidade?.isNotEmpty == true)
                _buildAddressRow(
                  context,
                  Icons.location_city,
                  'Cidade',
                  '${address.localidade!}${address.uf != null ? ' - ${address.uf}' : ''}',
                ),
              
              if (address.complemento?.isNotEmpty == true)
                _buildAddressRow(
                  context,
                  Icons.info_outline,
                  'Complemento',
                  address.complemento!,
                ),
              
              const SizedBox(height: AppMetrics.marginMedium),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _openInMaps(),
                      icon: const Icon(Icons.map, size: 18),
                      label: const Text('Ver no Mapa'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppMetrics.marginSmall),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _getDirections(),
                      icon: const Icon(Icons.directions, size: 18),
                      label: const Text('Rota'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                        side: const BorderSide(color: AppColors.secondary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAddressRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppMetrics.marginSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: AppMetrics.iconSmall,
            color: AppColors.grey,
          ),
          const SizedBox(width: AppMetrics.marginSmall),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _openInMaps() async {
    final query = address.fullAddress;

    // Web-safe: open Google Maps search URL
    if (kIsWeb) {
      final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
      await _safeLaunch(url);
      return;
    }

    // Mobile: use map_launcher when available
    try {
      final availableMaps = await MapLauncher.installedMaps;
      if (availableMaps.isNotEmpty) {
        await availableMaps.first.showMarker(
          coords: await _getCoordinates(),
          title: address.logradouro ?? 'Endereço',
          description: address.fullAddress,
        );
        return;
      }
    } catch (_) {
      // ignore and fallback below
    }

    // Fallback to Google Maps URL on mobile if plugin errors or no maps available
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
    await _safeLaunch(url);
  }
  
  Future<void> _getDirections() async {
    final destination = address.fullAddress;

    // Web-safe: open Google Maps directions URL
    if (kIsWeb) {
      final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(destination)}');
      await _safeLaunch(url);
      return;
    }

    // Mobile: use map_launcher when available
    try {
      final availableMaps = await MapLauncher.installedMaps;
      if (availableMaps.isNotEmpty) {
        await availableMaps.first.showDirections(
          destination: await _getCoordinates(),
          destinationTitle: address.logradouro ?? 'Destino',
        );
        return;
      }
    } catch (_) {
      // ignore and fallback below
    }

    // Fallback to Google Maps URL on mobile
    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(destination)}');
    await _safeLaunch(url);
  }

  Future<void> _safeLaunch(Uri url) async {
    try {
      // On web, platformDefault opens a new tab; on mobile, externalApplication opens respective app/browser
      final can = await canLaunchUrl(url);
      if (can) {
        await launchUrl(
          url,
          mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
        );
      }
    } catch (_) {
      // Silently ignore to avoid crashing the UI
    }
  }
  
  Future<Coords> _getCoordinates() async {
    try {
      // Avoid using geocoding on web to prevent MissingPluginException
      if (!kIsWeb) {
        final locations = await locationFromAddress(address.fullAddress);
        if (locations.isNotEmpty) {
          final location = locations.first;
          return Coords(location.latitude, location.longitude);
        }
      }
    } catch (e) {
      // Ignore error and use default coordinates
    }
    
    // Default coordinates (São Paulo)
    return Coords(-23.5505, -46.6333);
  }
}