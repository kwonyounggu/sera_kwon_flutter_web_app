import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async'; // Import for Timer

class DesktopSearchBar extends StatefulWidget implements PreferredSizeWidget 
{
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCancelSearch;
  final String initialQuery;

  const DesktopSearchBar
  (
    {
      super.key,
      required this.onSearchChanged,
      required this.onCancelSearch,
      this.initialQuery = ''
    }
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<DesktopSearchBar> createState() => _DesktopSearchBarState();
}

class _DesktopSearchBarState extends State<DesktopSearchBar> 
{
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _showClearButton = false;

  @override
  void initState() 
  {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _focusNode = FocusNode();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() 
  {
    setState(() => _showClearButton = _controller.text.isNotEmpty);
    widget.onSearchChanged(_controller.text);
  }

  void _onFocusChanged() 
  {
    setState(() {}); // Trigger rebuild for focus-based styling
  }

  void _clearSearch() 
  {
    _controller.clear();
    widget.onCancelSearch();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) 
  {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: kToolbarHeight,
      title: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              size: 24,
            ),
            suffixIcon: AnimatedOpacity(
              opacity: _showClearButton ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                icon: Icon(
                  Icons.cancel_rounded,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                onPressed: _clearSearch,
              ),
            ),
            hintText: 'Search blogs and comments...',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.text,
          onSubmitted: (value) => _focusNode.unfocus(),
        ),
      ),
    );
  }

  @override
  void dispose() 
  {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}