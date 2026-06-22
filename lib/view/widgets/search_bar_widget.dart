import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../models/location_model.dart';
import '../../theme/app_theme.dart';

class SearchBarWidget extends StatefulWidget {
  final String hint;
  final Function(LocationModel) onLocationSelected;
  final VoidCallback? onClose;

  const SearchBarWidget({
    super.key,
    required this.hint,
    required this.onLocationSelected,
    this.onClose,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focus = FocusNode();
  List<_Result> _results = [];
  bool _searching = false;
  DateTime _lastSearch = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String q) {
    if (q.length < 3) { setState(() => _results = []); return; }
    _lastSearch = DateTime.now();
    final t = _lastSearch;
    Future.delayed(const Duration(milliseconds: 600), () {
      if (t == _lastSearch) _search(q);
    });
  }

  Future<void> _search(String q) async {
    setState(() => _searching = true);
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search'
              '?format=json&q=${Uri.encodeComponent(q)}&limit=6&addressdetails=1');
      final res = await http.get(url, headers: {
        'User-Agent': 'RideApp/1.0', 'Accept-Language': 'en'
      });
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        setState(() {
          _results = data.map((item) => _Result(
            display: _format(item),
            full: item['display_name'] ?? '',
            latLng: LatLng(
                double.parse(item['lat']), double.parse(item['lon'])),
          )).toList();
        });
      }
    } catch (_) {
    } finally {
      setState(() => _searching = false);
    }
  }

  String _format(Map<String, dynamic> item) {
    final a = item['address'] as Map<String, dynamic>?;
    if (a == null) return item['display_name'] ?? '';
    final parts = <String>[];
    final road = a['road'] as String?;
    final house = a['house_number'] as String?;
    if (road != null) parts.add(house != null ? '$house $road' : road);
    final city = a['city'] as String? ?? a['town'] as String? ?? a['village'] as String?;
    if (city != null) parts.add(city);
    final post = a['postcode'] as String?;
    if (post != null) parts.add(post);
    return parts.isNotEmpty ? parts.join(', ') : item['display_name'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.darkBg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                        color: AppTheme.cardBg,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.arrow_back,
                        color: AppTheme.white, size: 18),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                        color: AppTheme.cardBg,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _ctrl,
                      focusNode: _focus,
                      onChanged: _onChanged,
                      style: AppTheme.valueStyle,
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle: AppTheme.hintStyle,
                        prefixIcon: const Icon(Icons.search,
                            color: const Color(0xFFB0B0B0), size: 18),
                        suffixIcon: _searching
                            ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(
                                  color: AppTheme.gold, strokeWidth: 2),
                            ))
                            : _ctrl.text.isNotEmpty
                            ? GestureDetector(
                            onTap: () {
                              _ctrl.clear();
                              setState(() => _results = []);
                            },
                            child: const Icon(Icons.close,
                                color: const Color(0xFFB0B0B0), size: 18))
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppTheme.darkGrey, height: 1),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _results.length,
            separatorBuilder: (_, __) =>
            const Divider(color: AppTheme.darkGrey, height: 1),
            itemBuilder: (_, i) {
              final r = _results[i];
              return GestureDetector(
                onTap: () => widget.onLocationSelected(
                    LocationModel(address: r.display, latLng: r.latLng)),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                            color: AppTheme.gold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.location_on,
                            color: AppTheme.gold, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.display, style: AppTheme.valueStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Text(r.full, style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 11),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          color: const Color(0xFFB0B0B0), size: 18),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Result {
  final String display;
  final String full;
  final LatLng latLng;
  _Result({required this.display, required this.full, required this.latLng});
}