import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/map_viewmodel.dart';
import '../../viewmodels/booking_viewmodel.dart';
import '../../viewmodels/driver_viewmodel.dart';
import '../../models/driver_model.dart';
import '../widgets/map_widget.dart';
import '../widgets/top_bar_widget.dart';
import '../widgets/center_pin_widget.dart';
import '../widgets/my_location_button.dart';
import '../widgets/booking_sheet_widget.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final driverVm = context.watch<DriverViewModel>();

    final isFinding = driverVm.isLooking;
    final isDriverOnWay = driverVm.driverFound &&
        driverVm.currentStatus != TripStatus.lookingForDriver;
    final isDriverMode = isFinding || isDriverOnWay;

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: Stack(
        children: [
          const MapWidget(),

          if (!isDriverMode) const TopBarWidget(),

          if (!isDriverMode) _movePinText(context),

          if (!isDriverMode) const CenterPinWidget(),

          if (!isDriverMode) const MyLocationButton(),

          if (isFinding) _findingDriverTopText(),
          if (isDriverOnWay) _driverOnWayTopText(driverVm),

          const BookingSheetWidget(),
        ],
      ),
    );
  }

  Widget _movePinText(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Positioned(
      top: topPad + 64,
      left: 16, right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'NATURAL GOOGLE MAP PREVIEW',
            style: TextStyle(
              color: AppTheme.goldLight,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.3,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Move pin to set pickup',
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _findingDriverTopText() {
    return Builder(builder: (context) {
      final topPad = MediaQuery.of(context).padding.top;
      return Positioned(
        top: topPad + 12, left: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'PAYMENT AUTHORISED',
              style: TextStyle(
                color: AppTheme.goldLight,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Finding your driver',
              style: TextStyle(
                color: AppTheme.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _driverOnWayTopText(DriverViewModel driverVm) {
    return Builder(builder: (context) {
      final topPad = MediaQuery.of(context).padding.top;
      return Positioned(
        top: topPad + 12, left: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (driverVm.driver?.etaMinutes != null &&
                driverVm.driver!.etaMinutes > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.goldLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  driverVm.driver!.etaText,
                  style: const TextStyle(
                    color: AppTheme.goldLight,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            const SizedBox(height: 6),
            const Text(
              'Driver on the way',
              style: TextStyle(
                color: AppTheme.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    });
  }
}