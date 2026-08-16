// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/app_loading_button.dart';
import 'package:dinar_store/core/widgets/defult_scaffold.dart';
import 'package:dinar_store/core/widgets/maps/app_map.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/auth/presentation/view_model/store_data_cubit/store_data_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class DataEditLocation extends StatefulWidget {
  const DataEditLocation({super.key, required this.position});

  final LatLng position;

  @override
  State<DataEditLocation> createState() => _DataEditLocationState();
}

class _DataEditLocationState extends State<DataEditLocation> {
  ///the store's saved coordinates come straight from the api. If they are not
  ///a drawable point the screen still has to open — correcting them is exactly
  ///what the owner came here to do
  late final LatLng _initialPosition =
      safeLatLng(widget.position.latitude, widget.position.longitude) ??
          kFallbackMapCenter;

  @override
  void initState() {
    super.initState();

    ///the google map seeded the pin from onMapCreated; flutter_map's onMapReady
    ///runs inside the map's initState, so emitting from there would rebuild the
    ///tree mid-build. Seeding after the first frame keeps the same behaviour —
    ///the store's saved location is already pinned when the screen opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileCubit>().addMarker(_initialPosition);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (_) {
        ProfileCubit.pickedPosition = null;
      },
      child: DefultScaffold(
        canPop: true,
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    blurRadius: 10.w,
                    spreadRadius: 15.w,
                    color: AppColors.kGrey,
                  )
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.w),
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      return FlutterMap(
                        options: MapOptions(
                          onTap: (_, LatLng point) {
                            context.read<ProfileCubit>().addMarker(point);
                          },
                          initialCenter: _initialPosition,

                          ///the google map clamped its zoom-18 camera to the
                          ///14..17 range below, so 17 is the zoom this screen
                          ///has always actually opened at
                          initialZoom: 17,
                          minZoom: 14,
                          maxZoom: 17,
                          interactionOptions: kPickerInteractionOptions,
                        ),
                        children: [
                          const AppTileLayer(),

                          ///the owner is placing their shop's pin, so the dot
                          ///showing where they are standing is the reference
                          ///they are placing it against — worth a fresh fix
                          const MyLocationLayer(requestFix: true),
                          MarkerLayer(
                            markers: [
                              AppMapMarker(
                                point: ProfileCubit.pickedPosition ??
                                    _initialPosition,
                              ),
                            ],
                          ),
                          const AppMapAttribution(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            BlocConsumer<StoreDataCubit, StoreDataState>(
              listener: (context, state) async {
                if (state is UpdateLocationFailure) {
                  context.showMessageSnackBar(
                    message: " خطأ أثناء تعديل الموقع ${state.errMessage}",
                  );
                }
                if (state is UpdateLocationSuccess) {
                  await context
                      .read<ProfileCubit>()
                      .getProfile(context: context);
                  Navigator.pop(context);
                  Navigator.pop(context);

                  context.showMessageSnackBar(
                    message: "تم تعديل الموقع بنجاح",
                  );
                }
              },
              builder: (context, state) {
                if (state is UpdateLocationLoading) {
                  return const AppLoadingButton();
                }
                return AppDefaultButton(
                  color: AppColors.primaryColor,
                  onPressed: () {
                    if (ProfileCubit.pickedPosition != null) {
                      context.read<StoreDataCubit>().updateLocation(
                            position: ProfileCubit.pickedPosition!,
                            profileModel: ProfileCubit.profileModel!,
                          );
                    }
                  },
                  title: 'حفظ الموقع',
                  textStyle: TextStyles.textStyle16.copyWith(
                    fontSize: 16.w,
                    color: AppColors.kWhite,
                  ),
                );
              },
            ),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }
}
