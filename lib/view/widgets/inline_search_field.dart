import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../models/location_model.dart';
import '../../theme/app_theme.dart';

class InlineSearchField extends StatefulWidget {
  final String label;
  final String initialValue;
  final Color dotColor;
  final Function(LocationModel) onSelected;
  final bool isLoading;

  const InlineSearchField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.dotColor,
    required this.onSelected,
    this.isLoading = false,
  });

  @override
  State<InlineSearchField> createState() => _InlineSearchFieldState();
}

class _InlineSearchFieldState extends State<InlineSearchField> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focus = FocusNode();
  bool _isExpanded = false;
  bool _searching = false;
  List<_Result> _results = [];
  DateTime _lastSearch = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ctrl.text = widget.initialValue;
    _focus.addListener(() {
      setState(() => _isExpanded = _focus.hasFocus);
      if (!_focus.hasFocus) {
        _ctrl.text = widget.initialValue;
        setState(() => _results = []);
      }
    });
  }

  @override
  void didUpdateWidget(InlineSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focus.hasFocus && oldWidget.initialValue != widget.initialValue) {
      _ctrl.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String q) {
    if (q.length < 3) {
      setState(() => _results = []);
      return;
    }
    _lastSearch = DateTime.now();
    final t = _lastSearch;
    Future.delayed(const Duration(milliseconds: 600), () {
      if (t == _lastSearch && mounted) _search(q);
    });
  }

  Future<void> _search(String q) async {
    setState(() => _searching = true);
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search'
              '?format=json&q=${Uri.encodeComponent(q)}&limit=5&addressdetails=1');
      final res = await http.get(url, headers: {
        'User-Agent': 'RideApp/1.0',
        'Accept-Language': 'en',
      });
      if (res.statusCode == 200 && mounted) {
        final List data = json.decode(res.body);
        setState(() {
          _results = data.map((item) => _Result(
            display: _format(item),
            full: item['display_name'] ?? '',
            latLng: LatLng(
              double.parse(item['lat']),
              double.parse(item['lon']),
            ),
          )).toList();
        });
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  String _format(Map<String, dynamic> item) {
    final a = item['address'] as Map<String, dynamic>?;
    if (a == null) return item['display_name'] ?? '';
    final parts = <String>[];
    final road = a['road'] as String?;
    final house = a['house_number'] as String?;
    if (road != null) parts.add(house != null ? '$house $road' : road);
    final city = a['city'] as String? ??
        a['town'] as String? ??
        a['village'] as String?;
    if (city != null) parts.add(city);
    final post = a['postcode'] as String?;
    if (post != null) parts.add(post);
    return parts.isNotEmpty ? parts.join(', ') : item['display_name'] ?? '';
  }

  void _onResultTap(_Result r) {
    final loc = LocationModel(address: r.display, latLng: r.latLng);
    _ctrl.text = r.display;
    _focus.unfocus();
    setState(() {
      _results = [];
      _isExpanded = false;
    });
    widget.onSelected(loc);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: _isExpanded && _results.isNotEmpty
                ? const BorderRadius.vertical(top: Radius.circular(12))
                : BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 9, height: 9,
                decoration: BoxDecoration(
                  color: widget.dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.label,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 2),

                    widget.isLoading
                        ? const SizedBox(
                        height: 14, width: 140,
                        child: LinearProgressIndicator(
                          backgroundColor: const Color(0xFF2A2A2A),
                          color: const Color(0xFFC8973A),
                        ))
                        : TextField(
                      controller: _ctrl,
                      focusNode: _focus,
                      onChanged: _onChanged,
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Search location...',
                        hintStyle: AppTheme.hintStyle,
                      ),
                    ),
                  ],
                ),
              ),

              if (_searching)
                const SizedBox(
                  width: 14, height: 14,
                  child: CircularProgressIndicator(
                      color: const Color(0xFFC8973A), strokeWidth: 1.5),
                ),

              if (_isExpanded && _ctrl.text.isNotEmpty && !_searching)
                GestureDetector(
                  onTap: () {
                    _ctrl.clear();
                    setState(() => _results = []);
                  },
                  child: const Icon(Icons.close,
                      color: const Color(0xFFB0B0B0), size: 16),
                ),
            ],
          ),
        ),

        if (_results.isNotEmpty)
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Column(
              children: [
                const Divider(
                    color: AppTheme.darkGrey, height: 1, thickness: 0.5),
                ..._results.map((r) => GestureDetector(
                  onTap: () => _onResultTap(r),
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC8973A).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.location_on,
                              color: const Color(0xFFC8973A), size: 14),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.display,
                                  style: const TextStyle(
                                    color: AppTheme.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text(r.full,
                                  style: AppTheme.hintStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
      ],
    );
  }
}

class _Result {
  final String display;
  final String full;
  final LatLng latLng;
  _Result({required this.display, required this.full, required this.latLng});
}