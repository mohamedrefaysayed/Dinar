import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/features/auth/presentation/view_model/location_cubit/cubit/location_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/order_cubit/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderLocationMap extends StatefulWidget {
  const OrderLocationMap({
    super.key,
  });

  @override
  State<OrderLocationMap> createState() => _OrderLocationMapState();
}

class _OrderLocationMapState extends State<OrderLocationMap> {
  @override
  void initState() {
    context.read<LocationCubit>().getCurrentLocation(context: context);
    super.initState();
  }

  Position? position;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LocationCubit, LocationState>(
        listener: (context, state) {
          if (state is LocationSuccess) {
            position = state.position;
          }
        },
        builder: (context, state) {
          if (state is LocationSuccess) {
            return BlocBuilder<OrderCubit, OrderState>(
              builder: (context, state) {
                return Column(
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
                          child: GoogleMap(
                            onTap: (position) {
                              context.read<OrderCubit>().addMarker(position);
                            },
                            myLocationButtonEnabled: false,
                            mapToolbarEnabled: false,
                            minMaxZoomPreference:
                                const MinMaxZoomPreference(14, 17),
                            markers: {
                              if (OrderCubit.marker != null) OrderCubit.marker!,
                            },
                            compassEnabled: false,
                            zoomControlsEnabled: false,
                            myLocationEnabled: true,
                            initialCameraPosition: CameraPosition(
                              zoom: 18,
                              target: LatLng(
                                position!.latitude,
                                position!.longitude,
                              ),
                            ),
                            onMapCreated: (GoogleMapController controller) {},
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 10.w),
                      child: OrderCubit.marker == null
                          ? Text(
                              "أختر موقع التوصيل",
                              style: TextStyles.textStyle14,
                            )
                          : Wrap(
                              children: [
                                Text(
                                  OrderCubit.currentAddress,
                                  style: TextStyles.textStyle14
                                      .copyWith(overflow: TextOverflow.visible),
                                ),
                              ],
                            ),
                    ),
                    Center(
                      child: AppDefaultButton(
                        width: 100.w,
                        height: 40.w,
                        color: AppColors.primaryColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        title: 'تم',
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                );
              },
            );
          }
          return const SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text("...جارى تحديد الموقع"),
              ],
            ),
          );
        },
      ),
    );
  }
}
