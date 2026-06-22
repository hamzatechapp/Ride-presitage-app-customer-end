import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/map_viewmodel.dart';
import '../../viewmodels/booking_viewmodel.dart';
import '../../viewmodels/driver_viewmodel.dart';
import '../../models/driver_model.dart';
import '../../models/location_model.dart';
import 'inline_search_field.dart';
import 'stop_search_sheet.dart';
import 'location_field_card.dart';
import 'finding_driver_widget.dart';
import 'driver_on_way_widget.dart';
import 'pickup_time_sheet.dart';
import 'vehicle_sheet.dart';
import 'payment_sheet.dart';
import 'confirm_sheet.dart';

const Color _textGrey = Color(0xFFB0B0B0);
const Color _accent = Color(0xFFC8973A);

class BookingSheetWidget extends StatelessWidget {
  const BookingSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bookVm = context.watch<BookingViewModel>();
    final driverVm = context.watch<DriverViewModel>();

    final isFinding = driverVm.isLooking;
    final isDriverOnWay = driverVm.driverFound &&
        driverVm.currentStatus != TripStatus.lookingForDriver;
    final isDriverMode = isFinding || isDriverOnWay;

    return DraggableScrollableSheet(
      key: ValueKey(isDriverMode),
      initialChildSize: isDriverMode ? 0.55 : 0.28,
      minChildSize: isDriverMode ? 0.55 : 0.12,
      maxChildSize: isDriverMode ? 0.55 : 0.92,
      builder: (context, scrollCtrl) {
        return Container(
          decoration: isDriverMode
              ? const BoxDecoration(color: Colors.transparent)
              : AppTheme.bottomPanelDecoration,
          child: ListView(
            controller: scrollCtrl,
            padding: EdgeInsets.zero,
            children: [
              _handle(),
              if (isDriverOnWay)
                const DriverOnWayWidget()
              else if (isFinding)
                const FindingDriverWidget()
              else
                _buildBookingPanel(context, bookVm),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookingPanel(BuildContext context, BookingViewModel bookVm) {
    final mapVm = context.watch<MapViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Center(
            child: Text(
              'Drag down for full map · drag up for full booking',
              style: TextStyle(color: _textGrey, fontSize: 10),
            ),
          ),
          const SizedBox(height: 10),

          const Text(
            'Book your ride',
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 14),

          InlineSearchField(
            label: 'PICKUP',
            initialValue: mapVm.pickupAddress,
            dotColor: _accent,
            isLoading: mapVm.isLoadingAddress,
            onSelected: (location) {
              context.read<MapViewModel>().onLocationSelected(location);
              context.read<BookingViewModel>().setPickup(location);
            },
          ),
          const SizedBox(height: 8),

          ...bookVm.stops.map((stop) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: LocationFieldCard(
              label: stop.label,
              value: stop.location.address,
              dotColor: _textGrey,
              trailing: removeStopButton(() =>
                  context.read<BookingViewModel>().removeStop(stop.id)),
              onTap: () => _showStopSearch(
                context,
                hint: 'Search ${stop.label.toLowerCase()} location...',
                onSelected: (LocationModel loc) => context
                    .read<BookingViewModel>()
                    .onLocationSelected(loc),
                fieldId: 'stop_${stop.id}',
              ),
            ),
          )),

          LocationFieldCard(
            label: 'DROP-OFF',
            value: bookVm.dropoff.address,
            dotColor: _accent,
            trailing: addStopButton(
                    () => context.read<BookingViewModel>().addStop()),
            onTap: () => _showStopSearch(
              context,
              hint: 'Search drop-off location...',
              onSelected: (LocationModel loc) {
                context.read<BookingViewModel>().openSearchFor('dropoff');
                context.read<BookingViewModel>().onLocationSelected(loc);
              },
              fieldId: 'dropoff',
            ),
          ),
          const SizedBox(height: 16),

          _rowTile(
            context,
            iconAsset: 'assets/icons/time.png',
            title: 'Pickup time',
            subtitle: bookVm.pickupTimeText,
            onTap: () => _showSheet(context, const PickupTimeSheet()),
          ),
          const SizedBox(height: 8),

          if (bookVm.isImmediate)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _accent.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Immediate pickup',
                    style: TextStyle(
                      color:Color(0xFFFFF1C5),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'After payment authorisation, the request goes live and the app starts looking for a driver.',
                    style: TextStyle(color: _textGrey, fontSize: 11),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),

          _rowTile(
            context,
            iconAsset: 'assets/icons/car.png',
            title: 'Vehicle type',
            subtitle: bookVm.vehicleType,
            onTap: () => _showSheet(context, const VehicleSheet()),
          ),
          const SizedBox(height: 8),

          _rowTile(
            context,
            iconAsset: 'assets/icons/payment.png',
            title: 'Payment method',
            subtitle: bookVm.paymentMethod,
            onTap: () => _showSheet(context, const PaymentSheet()),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: AppTheme.cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('NOTES FOR DRIVER',
                    style: TextStyle(
                      color: _textGrey,
                      fontSize: 10,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (v) =>
                      context.read<BookingViewModel>().setNotesForDriver(v),
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Any special instructions',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 13),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: AppTheme.cardDecoration,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ESTIMATED FARE',
                          style: TextStyle(
                            color: _textGrey,
                            fontSize: 10,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(height: 4),
                      Text(
                        bookVm.distanceDisplay,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  bookVm.fareDisplay,
                  style: const TextStyle(
                    color: _accent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: bookVm.isReadyToConfirm
                  ? () {
                context.read<BookingViewModel>().setPickup(mapVm.pickup);
                _showSheet(context, const ConfirmSheet());
              }
                  : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Confirm and Request',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios,
                      color: Colors.black87, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _rowTile(
      BuildContext context, {
        required String iconAsset,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color(0xFF2A2A2A), width: 0.5)),
        ),
        child: Row(
          children: [
            Image.asset(
              iconAsset,
              width: 22, height: 22,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.circle_outlined,
                color: _textGrey, size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: _textGrey, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: _accent, size: 14),
          ],
        ),
      ),
    );
  }

  void _showStopSearch(
      BuildContext context, {
        required String hint,
        required void Function(LocationModel) onSelected,
        required String fieldId,
      }) {
    context.read<BookingViewModel>().openSearchFor(fieldId);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.sheetBg,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StopSearchSheet(
        hint: hint,
        onSelected: (LocationModel loc) {
          onSelected(loc);
          context.read<BookingViewModel>().closeSearch();
        },
      ),
    ).whenComplete(() {
      context.read<BookingViewModel>().closeSearch();
    });
  }

  void _showSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.sheetBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
              value: context.read<BookingViewModel>()),
          ChangeNotifierProvider.value(
              value: context.read<DriverViewModel>()),
        ],
        child: child,
      ),
    );
  }

  Widget _handle() => Column(
    children: [
      const SizedBox(height: 12),
      Center(
        child: Container(
          width: 40, height: 4,
          decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
      const SizedBox(height: 8),
    ],
  );
}