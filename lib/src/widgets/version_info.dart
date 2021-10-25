import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/device_info/device_info_bloc.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class VersionInfo extends StatelessWidget {
  const VersionInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceInfoBloc, DeviceInfoState>(
      builder: (context, state) {
        if (state is DeviceInfoFetchedSuccessfullyState) {
          return Text(
            '${LocaleKeys.version.tr()}: '
            '${state.deviceInfoModel.appVersion}'
            ' (${state.deviceInfoModel.appBuildNumber})',
            style: AppStyles.drawerAppVersion,
            textAlign: TextAlign.center,
          );
        }
        return Container();
      },
    );
  }
}
