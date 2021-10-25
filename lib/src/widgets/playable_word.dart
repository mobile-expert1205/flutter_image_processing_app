import 'package:flutter/material.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/src/common/app_assets.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';
import 'package:wordfinderx/src/widgets/common.dart';

class PlayableWord extends StatelessWidget {
  final String word;
  final SearchDictionary searchDictionary;
  final int points;

  const PlayableWord({
    Key? key,
    required this.word,
    required this.searchDictionary,
    required this.points,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String textLine1 = '$word ${LocaleKeys.isPlayableIn.tr()} '
        '${getDictionaryName(searchDictionary)}'
        '${LocaleKeys.exclamation.tr()}';
    final String textLine2 = '($points ${LocaleKeys.points.tr()})';
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textLine1,
              style: AppStyles.playableCardText,
              textAlign: TextAlign.center,
            ),
            SizedBox.fromSize(size: Size.fromHeight(10.0)),
            Image.asset(
              AppAssets.playableWordIcon,
              width: 37.0,
              height: 27.0,
            ),
            SizedBox.fromSize(size: Size.fromHeight(10.0)),
            Text(
              textLine2,
              style: AppStyles.playableCardText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
