import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:fastlocation/src/modules/history/controller/history_controller.dart';
import 'package:fastlocation/src/modules/home/components/address_result_card.dart';
import 'package:fastlocation/src/shared/components/loading_widget.dart';
import 'package:fastlocation/src/shared/components/empty_state_widget.dart';
import 'package:fastlocation/src/shared/components/error_widget.dart';
import 'package:fastlocation/src/shared/colors/app_colors.dart';
import 'package:fastlocation/src/shared/metrics/app_metrics.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryController _controller = HistoryController();
  
  @override
  void initState() {
    super.initState();
    _controller.loadHistory();
    _setupReactions();
  }
  
  void _setupReactions() {
   
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
        title: Observer(
          builder: (_) => Text(
            'Histórico${_controller.hasAddresses ? ' (${_controller.totalAddresses})' : ''}',
          ),
        ),
        actions: [
          Observer(
            builder: (_) => _controller.hasAddresses
                ? PopupMenuButton<String>(
                    onSelected: _onMenuSelected,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'clear_all',
                        child: Row(
                          children: [
                            Icon(Icons.clear_all, color: AppColors.error),
                            SizedBox(width: 8),
                            Text('Limpar Histórico'),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_controller.isLoading) {
            return const Center(
              child: LoadingWidget(message: 'Carregando histórico...'),
            );
          }
          
          if (_controller.hasError) {
            return CustomErrorWidget(
              message: _controller.errorMessage!,
              onRetry: _controller.loadHistory,
            );
          }
          
          if (!_controller.hasAddresses) {
            return const EmptyStateWidget(
              title: 'Histórico vazio',
              description: 'Você ainda não realizou nenhuma consulta.\n\nQuando buscar endereços, eles aparecerão aqui.',
              icon: Icons.history,
            );
          }
          
          return RefreshIndicator(
            onRefresh: _controller.loadHistory,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: AppMetrics.paddingMedium,
              ),
              itemCount: _controller.addresses.length,
              separatorBuilder: (context, index) => const SizedBox(
                height: AppMetrics.marginSmall,
              ),
              itemBuilder: (context, index) {
                final address = _controller.addresses[index];
                
                return Dismissible(
                  key: ValueKey(address.cep),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppMetrics.paddingLarge),
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppMetrics.marginMedium,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(AppMetrics.borderRadiusMedium),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          color: AppColors.onError,
                          size: AppMetrics.iconLarge,
                        ),
                        Text(
                          'Excluir',
                          style: TextStyle(
                            color: AppColors.onError,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  confirmDismiss: (direction) => _showDeleteConfirmation(address),
                  onDismissed: (direction) {
                    _controller.deleteAddress(address);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Endereço removido do histórico'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (address.consultedAt != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppMetrics.paddingMedium,
                          ),
                          child: Text(
                            _controller.formatDate(address.consultedAt),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      AddressResultCard(
                        address: address,
                        isLastSearched: index == 0,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
  
  void _onMenuSelected(String value) {
    switch (value) {
      case 'clear_all':
        _showClearAllConfirmation();
        break;
    }
  }
  
  Future<bool?> _showDeleteConfirmation(address) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir endereço'),
        content: Text('Deseja remover este endereço do histórico?\n\n${address.fullAddress}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
  
  void _showClearAllConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar histórico'),
        content: const Text('Deseja remover todos os endereços do histórico? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _controller.clearHistory();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Histórico limpo com sucesso'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Limpar Tudo'),
          ),
        ],
      ),
    );
  }
}