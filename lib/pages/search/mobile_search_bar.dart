import 'package:drkwon/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';

class MobileSearchScreen extends StatefulWidget 
{
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCancelSearch;
  final String? previousPath;

  const MobileSearchScreen({super.key, required this.onSearchChanged, required this.onCancelSearch, this.previousPath});

  @override
  // ignore: library_private_types_in_public_api
  _MobileSearchScreenState createState() => _MobileSearchScreenState();
}

class _MobileSearchScreenState extends State<MobileSearchScreen> 
{
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showClearButton = false;
  Timer? _debounceTimer;

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
    return Scaffold(
      appBar: ResponsiveWidget.isMobile(context) ? AppBar
      (
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: IconButton
        (
          icon: const Icon(Icons.arrow_back),
          onPressed: () 
          {
            if (widget.previousPath != null)
            {
              context.go(widget.previousPath!);
            }
            else 
            {
              context.go('/');
            }
          }
        ),
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
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                size: 24,
              ),
              suffixIcon: AnimatedOpacity(
                opacity: _showClearButton ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: IconButton(
                  icon: Icon(
                      Icons.cancel_rounded,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
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
      ) : null,
      body: // Widget to display search results based on _searchController.text
          const Center(
        child: Text('Search Results will appear here'),
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}