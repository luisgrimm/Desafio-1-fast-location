import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:fastlocation/src/modules/home/controller/home_controller.dart';
import 'package:fastlocation/src/modules/home/components/address_search_form.dart';
import 'package:fastlocation/src/modules/home/components/address_result_card.dart';
import 'package:fastlocation/src/modules/home/components/search_results_list.dart';
import 'package:fastlocation/src/modules/history/page/history_page.dart';
import 'package:fastlocation/src/shared/components/loading_widget.dart';
import 'package:fastlocation/src/shared/components/empty_state_widget.dart';
import 'package:fastlocation/src/shared/components/error_widget.dart';
import 'package:fastlocation/src/shared/colors/app_colors.dart';
import 'package:fastlocation/src/shared/metrics/app_metrics.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  
  @override
  void initState() {
    super.initState();
    _setupReactions();
  }
  
  void _setupReactions() {
    // Reação para mostrar erros
    reaction(
      (_) => _controller.errorMessage,
      (String? error) {
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'OK',
                textColor: AppColors.onError,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FastLocation'),
        centerTitle: true,
        actions: [
          Observer(
            builder: (_) => IconButton(
              onPressed: () => _navigateToHistory(),
              icon: const Icon(Icons.history),
              tooltip: 'Histórico',
            ),
          ),
          IconButton(
            onPressed: () => _controller.clearCurrentSearch(),
            icon: const Icon(Icons.clear_all),
            tooltip: 'Limpar',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: AppMetrics.marginMedium),
              AddressSearchForm(
                onCepSearch: _controller.searchByCep,
                onAddressSearch: (city, state, street) => _controller.searchByAddress(
                  city: city,
                  state: state,
                  street: street,
                ),
                isLoading: _controller.isLoading,
              ),
              
              Observer(
                builder: (_) {
                  if (_controller.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(AppMetrics.paddingLarge),
                      child: LoadingWidget(message: 'Buscando endereço...'),
                    );
                  }
                  
                  if (_controller.hasError) {
                    return CustomErrorWidget(
                      message: _controller.errorMessage!,
                      onRetry: () {
                        // A ação de retry será definida baseada na última busca
                      },
                    );
                  }
                  
                  if (_controller.hasSearchResults) {
                    return SearchResultsList(
                      addresses: _controller.searchResults,
                      onAddressSelected: _controller.selectAddressFromResults,
                    );
                  }
                  
                  if (_controller.hasCurrentAddress) {
                    return AddressResultCard(
                      address: _controller.currentAddress!,
                    );
                  }
                  
                  return _buildInitialState();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInitialState() {
    return Observer(
      builder: (_) {
        final lastAddress = _controller.lastSearchedAddress;
        
        if (lastAddress != null) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppMetrics.paddingMedium,
                  vertical: AppMetrics.paddingSmall,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Última consulta:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGrey,
                    ),
                  ),
                ),
              ),
              AddressResultCard(
                address: lastAddress,
                isLastSearched: true,
              ),
              const SizedBox(height: AppMetrics.marginMedium),
              if (_controller.hasHistory)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppMetrics.paddingMedium,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _navigateToHistory,
                      icon: const Icon(Icons.history),
                      label: const Text('Ver Histórico Completo'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }
        
        return const EmptyStateWidget(
          title: 'Bem-vindo ao FastLocation!',
          description: 'Consulte endereços pelo CEP ou encontre CEPs através de endereços.\n\nPara começar, use o formulário acima.',
          icon: Icons.location_searching,
        );
      },
    );
  }
  
  void _navigateToHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HistoryPage(),
      ),
    );
  }
}