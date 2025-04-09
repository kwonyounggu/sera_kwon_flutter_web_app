import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async'; // Import for Timer

class DesktopSearchBar extends StatefulWidget implements PreferredSizeWidget 
{
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCancelSearch;

  const DesktopSearchBar
  (
    {
      super.key,
      required this.onSearchChanged,
      required this.onCancelSearch,
    }
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<DesktopSearchBar> createState() => _ProfessionalSearchBarState();
}

class _ProfessionalSearchBarState extends State<DesktopSearchBar> 
{
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showClearButton = false;
  Timer? _debounceTimer; // Timer for debouncing

  @override
  void initState() 
  {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() 
  {
    setState(() => _showClearButton = _controller.text.isNotEmpty);
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {widget.onSearchChanged(_controller.text);});
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
    return AppBar
    (
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      title: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        height: 40,
        decoration: BoxDecoration
        (
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
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
                onPressed: _clearSearch,
              ),
            ),
            hintText: 'Search blogs and comments...',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.text,
          onSubmitted: (value) => _focusNode.unfocus(),
        ),
      ),
      /*actions: [ //uncomment if you need the cancel button later
        AnimatedOpacity(
          opacity: _controller.text.isNotEmpty ? 1.0 : 0.0, // Show if there is text
          duration: const Duration(milliseconds: 200),
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: _clearSearch,
            child: const Text('Cancel'),
          ),
        ),
      ],*/
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel(); // Cancel the timer if the widget is disposed
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}