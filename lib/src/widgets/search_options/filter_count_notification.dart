import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordfinderx/src/blocs/input/input_bloc.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';

class FilterCountNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InputBloc, InputState>(
      buildWhen: _buildWhen,
      builder: _builder,
    );
  }

  bool _buildWhen(InputState previous, InputState current) =>
      previous.filledFilterCount != current.filledFilterCount;

  Widget _builder(BuildContext context, InputState state) {
    if (state.filledFilterCount == 0) return Container();

    return Container(
      padding: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.usedFilterCountBg,
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          '${state.filledFilterCount}',
          style: AppStyles.usedFilterCount,
        ),
      ),
    );
  }
}
