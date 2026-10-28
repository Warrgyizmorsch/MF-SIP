import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_sip/core/network/network_api_service.dart';
import '../../data/datasource/ticket_remote_ds.dart';
import '../../data/repositories/ticket_repo_impl.dart';
import '../../domain/entities/ticket_entity.dart';
import '../../domain/usecases/ticket_usecases.dart';

class TicketsController extends GetxController {
  final GetTicketsUseCase getTicketsUseCase;

  TicketsController({GetTicketsUseCase? useCase})
      : getTicketsUseCase = useCase ??
            GetTicketsUseCase(
              TicketRepoImpl(
                TicketRemoteDs(NetworkServicesApi()),
              ),
            );

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;

  final tickets = <TicketEntity>[].obs;
  final selectedTab = 'OPEN_ONLY'.obs; // 'OPEN_ONLY', 'RESOLVED_ONLY', 'ALL'

  final openCount = 0.obs;
  final resolvedCount = 0.obs;
  final totalCount = 0.obs;

  int _currentPage = 1;
  final hasMore = false.obs;

  late final ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    fetchTickets();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (hasMore.value && !isLoadingMore.value && !isLoading.value) {
        loadMore();
      }
    }
  }

  void changeTab(String tab) {
    if (selectedTab.value == tab) return;
    selectedTab.value = tab;
    fetchTickets(isRefresh: true);
  }

  Future<void> fetchTickets({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
    } else {
      isLoading.value = true;
    }
    errorMessage.value = '';

    final result = await getTicketsUseCase(
      status: selectedTab.value,
      page: _currentPage,
      perPage: 15,
    );

    result.fold(
      (success) {
        final data = success.data;
        if (data != null) {
          openCount.value = data.summary.openCount;
          resolvedCount.value = data.summary.resolvedCount;
          totalCount.value = data.summary.total;
          hasMore.value = data.hasMore;

          if (isRefresh || _currentPage == 1) {
            tickets.assignAll(data.tickets);
          } else {
            tickets.addAll(data.tickets);
          }
        }
      },
      (error) {
        errorMessage.value = error.message;
      },
    );

    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;

    isLoadingMore.value = true;
    _currentPage++;

    final result = await getTicketsUseCase(
      status: selectedTab.value,
      page: _currentPage,
      perPage: 15,
    );

    result.fold(
      (success) {
        final data = success.data;
        if (data != null) {
          hasMore.value = data.hasMore;
          tickets.addAll(data.tickets);
        }
      },
      (error) {
        // Stop pagination on error
        hasMore.value = false;
      },
    );

    isLoadingMore.value = false;
  }

  Future<void> onRefresh() async {
    await fetchTickets(isRefresh: true);
  }
}
