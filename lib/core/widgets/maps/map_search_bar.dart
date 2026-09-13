import 'dart:async';

import 'package:dinar_store/core/data/models/place_search_result.dart';
import 'package:dinar_store/core/data/services/place_search_services.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/home/data/repos/place_search_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A search box over a map picker: type a place, submit, tap a hit and the
/// map jumps there.
///
/// Searches go out on submit only, never per keystroke — nominatim's usage
/// policy forbids autocomplete and allows one request a second, and the
/// keyboard's search key is a single tap away anyway.
///
/// Sits at the top of the map in a [Stack]; [padding] keeps it clear of
/// whatever else the screen draws up there (the back arrow, for one).
class MapSearchBar extends StatefulWidget {
  const MapSearchBar({
    super.key,
    required this.mapController,
    required this.onPicked,
    this.padding,
    this.services,
  });

  final MapController mapController;

  /// called with the chosen hit after the camera has moved to it
  final ValueChanged<PlaceSearchResult> onPicked;

  final EdgeInsetsGeometry? padding;

  /// injected in tests; the real nominatim client otherwise
  final PlaceSearchRepo? services;

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final PlaceSearchRepo _services =
      widget.services ?? PlaceSearchServices();

  StreamSubscription<MapEvent>? _mapEvents;

  List<PlaceSearchResult> _results = const [];
  bool _searching = false;

  ///true between a search that came back empty and the next edit, so "no
  ///results" is shown once rather than every time the field is empty
  bool _noResults = false;

  @override
  void initState() {
    super.initState();

    ///a tap on the map means the user is placing the pin by hand now: drop
    ///the keyboard and the hits so they stop covering the map
    _mapEvents = widget.mapController.mapEventStream.listen((MapEvent event) {
      if (event is MapEventTap) _dismiss();
    });
  }

  @override
  void dispose() {
    _mapEvents?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _dismiss() {
    _focusNode.unfocus();
    if (_results.isEmpty && !_noResults) return;
    setState(() {
      _results = const [];
      _noResults = false;
    });
  }

  Future<void> _search(String query) async {
    final String trimmed = query.trim();
    if (trimmed.isEmpty || _searching) return;

    setState(() {
      _searching = true;
      _results = const [];
      _noResults = false;
    });

    final result = await _services.search(
      query: trimmed,
      near: widget.mapController.camera.visibleBounds,
    );
    if (!mounted) return;

    result.fold(
      //error
      (serverFailure) {
        setState(() => _searching = false);
        context.showMessageSnackBar(
          message: 'تعذر البحث: ${serverFailure.errMessage}',
        );
      },
      //success
      (places) {
        setState(() {
          _searching = false;
          _results = places;
          _noResults = places.isEmpty;
        });
      },
    );
  }

  void _pick(PlaceSearchResult place) {
    _controller.text = place.name;
    _dismiss();

    final LatLngBounds? bounds = place.bounds;
    if (bounds != null) {
      ///the map's own min/max zoom still apply: a whole city fits as far out
      ///as the picker allows, a single shop as far in
      widget.mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: EdgeInsets.all(40.w)),
      );
    } else {
      widget.mapController.move(
        place.point,
        widget.mapController.camera.zoom,
      );
    }
    widget.onPicked(place);
  }

  void _clear() {
    _controller.clear();
    setState(() {
      _results = const [];
      _noResults = false;
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: widget.padding ??
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildField(),
              if (_results.isNotEmpty || _noResults) ...[
                SizedBox(height: 6.h),
                _buildResults(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField() {
    return Material(
      color: AppColors.kWhite,
      elevation: 4,
      borderRadius: BorderRadius.circular(12.w),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        onSubmitted: _search,
        onChanged: (_) {
          if (_noResults) setState(() => _noResults = false);
        },
        style: TextStyles.textStyle14,
        decoration: InputDecoration(
          hintText: 'ابحث عن مكان',
          hintStyle: TextStyles.textStyle14.copyWith(color: AppColors.kGrey),
          border: InputBorder.none,
          isDense: true,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          prefixIcon: _searching
              ? Padding(
                  padding: EdgeInsets.all(12.w),
                  child: SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () => _search(_controller.text),
                  icon: const Icon(
                    Icons.search,
                    color: AppColors.primaryColor,
                  ),
                ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                onPressed: _clear,
                icon: const Icon(Icons.close, color: AppColors.kGrey),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    return Material(
      color: AppColors.kWhite,
      elevation: 4,
      borderRadius: BorderRadius.circular(12.w),
      clipBehavior: Clip.antiAlias,
      child: _noResults
          ? Padding(
              padding: EdgeInsets.all(12.w),
              child: Text(
                'لا توجد نتائج',
                style: TextStyles.textStyle14.copyWith(color: AppColors.kGrey),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _results.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final PlaceSearchResult place = _results[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.place_outlined,
                    color: AppColors.primaryColor,
                  ),
                  title: Text(
                    place.name,
                    style: TextStyles.textStyle12,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _pick(place),
                );
              },
            ),
    );
  }
}
