import 'dart:async';

import 'package:flutter/material.dart';
import 'package:partners/core/extension/extension.dart';
import 'package:partners/features/branches/domain/domain.dart';
import 'package:partners/features/branches/presentation/notifier/create_branch_form_notifier.dart';
import 'package:partners/features/branches/presentation/screens/create_branch_screen_strings.dart';
import 'package:partners/main.dart';

/// Bottom sheet de categorías: GET /options/categories, infinite scroll y búsqueda (filter local primero).
class CategoryBottomSheetContent extends StatefulWidget {
  final CreateBranchFormNotifier formNotifier;
  final VoidCallback onSelect;

  const CategoryBottomSheetContent({
    super.key,
    required this.formNotifier,
    required this.onSelect,
  });

  @override
  State<CategoryBottomSheetContent> createState() =>
      _CategoryBottomSheetContentState();
}

class _CategoryBottomSheetContentState extends State<CategoryBottomSheetContent> {
  final List<CategoryEntity> _categories = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  static const Duration _searchDebounceDuration = Duration(milliseconds: 800);
  Timer? _searchDebounce;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  String _keyword = '';
  bool _searchResultFromApi = false;

  @override
  void initState() {
    super.initState();
    _loadPage(1);
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<CategoryEntity> get _displayList {
    if (_keyword.isEmpty) return _categories;
    final lower = _keyword.toLowerCase();
    final local =
        _categories.where((c) => c.name.toLowerCase().contains(lower)).toList();
    return local.isNotEmpty ? local : _categories;
  }

  bool get _canLoadMore =>
      _hasMore && (_keyword.isEmpty || _searchResultFromApi);

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDebounceDuration, () {
      if (!mounted) return;
      final keyword = _searchController.text.trim();
      if (keyword == _keyword) return;
      setState(() {
        _keyword = keyword;
        _searchResultFromApi = false;
      });
      if (keyword.isEmpty) return;
      final lower = keyword.toLowerCase();
      final localMatch =
          _categories.any((c) => c.name.toLowerCase().contains(lower));
      if (localMatch) return;
      _loadPage(1, keyword: keyword);
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients || !_canLoadMore || _isLoading) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 100) {
      _loadPage(_page + 1, keyword: _keyword.isEmpty ? null : _keyword);
    }
  }

  Future<void> _loadPage(int page, {String? keyword}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    final result =
        await getIt<GetCategoriesUsecase>().call(page, keyword: keyword);
    if (!mounted) return;
    result.fold((_) => setState(() => _isLoading = false), (paginated) {
      setState(() {
        if (page == 1) _categories.clear();
        _categories.addAll(paginated.data);
        _hasMore = paginated.meta.hasNextPage;
        _page = page;
        _isLoading = false;
        if (keyword != null && keyword.isNotEmpty) _searchResultFromApi = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.6;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.appColor.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const SizedBox(width: 131, height: 5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  CreateBranchScreenStrings.chooseCategoryTitle,
                  style: TextStyle(
                    color: context.appColor.primary,
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: CreateBranchScreenStrings.categorySearchHint,
                    hintStyle: TextStyle(
                      color: context.appColor.onSurfaceVariant,
                      fontSize: 16,
                      fontFamily: 'Figtree',
                    ),
                    filled: true,
                    fillColor: context.appColor.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: TextStyle(
                    color: context.appColor.onSurface,
                    fontSize: 16,
                    fontFamily: 'Figtree',
                  ),
                ),
              ),
              Expanded(
                child: _displayList.isEmpty && !_isLoading
                    ? Center(
                        child: Text(
                          'No hay categorías',
                          style: TextStyle(
                            color: context.appColor.onSurfaceVariant,
                            fontSize: 16,
                            fontFamily: 'Figtree',
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        itemCount: _displayList.length +
                            (_canLoadMore && _isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= _displayList.length) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: context.appColor.primary,
                                ),
                              ),
                            );
                          }
                          final category = _displayList[index];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                widget.formNotifier.setCategory(category);
                                widget.onSelect();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  children: [
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: context.appColor.onSurface,
                                          width: 1,
                                        ),
                                      ),
                                      child: const SizedBox(
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    Text(
                                      category.name,
                                      style: TextStyle(
                                        color: context.appColor.onSurface,
                                        fontSize: 23,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Figtree',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
