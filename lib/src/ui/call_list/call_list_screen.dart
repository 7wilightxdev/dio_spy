import 'package:flutter/material.dart';

import '../../core/dio_spy_storage.dart';
import '../../models/http_call.dart';
import '../../utils/formatters.dart';
import '../call_detail/call_detail_screen.dart';
import '../theme.dart';
import '../widgets/filter_chips.dart';
import '../widgets/method_chip.dart';
import '../widgets/status_chip.dart';

class CallListScreen extends StatefulWidget {
  const CallListScreen({super.key, required this.storage, this.onBack});

  final DioSpyStorage storage;
  final VoidCallback? onBack;

  @override
  State<CallListScreen> createState() => _CallListScreenState();
}

class _CallListScreenState extends State<CallListScreen> {
  bool _searching = false;
  final _searchController = TextEditingController();
  Set<String> _filters = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DioSpyHttpCall> _filteredCalls(List<DioSpyHttpCall> calls) {
    return calls.where((call) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final matchesUrl = call.uri.toLowerCase().contains(_searchQuery) ||
            call.endpoint.toLowerCase().contains(_searchQuery) ||
            call.server.toLowerCase().contains(_searchQuery);
        if (!matchesUrl) return false;
      }

      // Chip filters
      if (_filters.isEmpty) return true;

      bool matchesStatus = false;
      bool matchesMethod = false;
      bool hasStatusFilter = false;
      bool hasMethodFilter = false;

      for (final f in _filters) {
        if (['2xx', '3xx', '4xx', '5xx'].contains(f)) {
          hasStatusFilter = true;
          final statusGroup = (call.response?.status ?? -1) ~/ 100;
          if (f == '${statusGroup}xx') matchesStatus = true;
        } else {
          hasMethodFilter = true;
          if (call.method.toUpperCase() == f) matchesMethod = true;
        }
      }

      final statusOk = !hasStatusFilter || matchesStatus;
      final methodOk = !hasMethodFilter || matchesMethod;
      return statusOk && methodOk;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = Theme(
      data: DioSpyTheme.themeData(context),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // Search bar
            if (_searching) _buildSearchBox(),

            // Filter chips
            _buildFilterChips(),

            const Divider(height: 1),

            // Call list
            Expanded(
              child: _buildCallListView(),
            ),
          ],
        ),
      ),
    );

    // When used inside DioSpyWrapper, intercept the system back button
    // to close the inspector instead of popping the root route.
    if (widget.onBack != null) {
      screen = PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) widget.onBack!();
        },
        child: screen,
      );
    }

    return screen;
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('SPY x DIO'),
      leading: widget.onBack != null ? BackButton(onPressed: widget.onBack) : null,
      actions: [
        IconButton(
          icon: Icon(_searching ? Icons.search_off : Icons.search),
          onPressed: () {
            setState(() {
              _searching = !_searching;
              if (!_searching) {
                _searchController.clear();
              }
            });
          },
        ),
        PopupMenuButton(
          icon: Icon(Icons.more_vert),
          offset: Offset(-22, 44),
          elevation: 2,
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: widget.storage.clear,
              child: Text(
                'Clear All',
                style: DioSpyTypo.t14.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBox() {
    return Container(
      color: DioSpyColors.surface,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: DioSpyTypo.t16.w500.primary,
        decoration: InputDecoration(
          hintText: 'Search by URL...',
          hintStyle: DioSpyTypo.t16.tertiary,
          filled: true,
          fillColor: DioSpyColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: DioSpyColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: DioSpyColors.surface,
      padding: const EdgeInsets.only(bottom: 16),
      child: FilterChips(
        selectedFilters: _filters,
        onChanged: (filters) => setState(() => _filters = filters),
      ),
    );
  }

  Widget _buildCallListView() {
    return ValueListenableBuilder(
      valueListenable: widget.storage.calls,
      builder: (context, calls, _) {
        final filtered = _filteredCalls(calls);

        if (filtered.isEmpty) {
          return Center(
            child: Text(
              calls.isEmpty ? 'No requests yet' : 'No matching requests',
              style: DioSpyTypo.t16.secondary,
            ),
          );
        }

        return Scrollbar(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return _CallListItem(
                call: filtered[index],
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CallDetailScreen(call: filtered[index]),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _CallListItem extends StatelessWidget {
  const _CallListItem({required this.call, required this.onTap});

  final DioSpyHttpCall call;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: DioSpyColors.surface),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            // Row 1: Method + Status + Duration + Size
            Row(
              children: [
                MethodChip(method: call.method),
                const SizedBox(width: 8),
                if (call.loading)
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else ...[
                  StatusChip(statusCode: call.response?.status),
                  if (call.error != null)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.warning_rounded,
                        size: 16,
                        color: DioSpyColors.error,
                      ),
                    ),
                ],
                const Spacer(),
                if (!call.loading) ...[
                  Text(
                    DioSpyFormatters.formatDuration(call.duration),
                    style: DioSpyTypo.t14.secondary,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('|', style: DioSpyTypo.t14.secondary),
                  ),
                  Text(
                    DioSpyFormatters.formatBytes(call.response?.size ?? 0),
                    style: DioSpyTypo.t14.secondary,
                  ),
                ],
              ],
            ),

            // Row 2: Endpoint
            Text(
              call.endpoint,
              style: DioSpyTypo.t16.w500.copyWith(
                color: call.error != null ? DioSpyColors.error : null,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Row 3: Server + Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    call.server,
                    style: DioSpyTypo.t12.w500.secondary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  DioSpyFormatters.formatTime(call.createdTime),
                  style: DioSpyTypo.t12.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
