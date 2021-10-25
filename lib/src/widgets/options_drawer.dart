import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/search_request_model.dart';
import 'package:wordfinderx/src/screens/image_upload.dart';
import 'package:wordfinderx/src/widgets/custom_radio.dart';
import 'package:wordfinderx/src/widgets/version_info.dart';
import 'package:wordfinderx/src/widgets/purchase/purchase_product_list.dart';
import 'package:image_picker/image_picker.dart';
import 'common.dart';

/// Implements Drawer to display and select options of the application.
class OptionsDrawer extends StatelessWidget {
  /// Instance of the BLoC to interact with.
  final SearchBloc searchBloc;

  /// Constructor.
  const OptionsDrawer({Key? key, required this.searchBloc}) : super(key: key);

  /// Describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.backgroundColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildOptions(),
          ),
        ),
      ),
    );
  }

  /// Builds all options to show in widget.
  Widget _buildOptions() {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      buildWhen: _optionsBuildWhen,
      builder: (BuildContext ctx, SearchState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOptionsTitle(LocaleKeys.selectGame.tr()),
            const SizedBox(height: 12),
            ..._buildDictionaryOptions(ctx, state),
            const SizedBox(height: 20),
            const Divider(height: 1, color: Colors.white),
            const SizedBox(height: 12),
            _buildPurchaseSubscription(ctx),
            _buildContact(),
            _buildUploadImage(ctx),
            Expanded(child: Container()),
            VersionInfo(),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  /// Builds options title.
  Text _buildOptionsTitle(String title) {
    return Text(title, style: AppStyles.drawerOptionsTitle);
  }

  /// Determines when widget should be rebuild.
  bool _optionsBuildWhen(SearchState previous, SearchState current) =>
      previous.searchDictionary != current.searchDictionary;

  /// Builds option item with given parameters.
  Widget _buildOption({
    required String title,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return MaterialButton(
      onPressed: onPressed,
      child: Row(
        children: [
          CustomRadio<bool>(
            value: true,
            groupValue: isSelected,
            onChanged: (_) => onPressed(),
            outerColor: Colors.white,
          ),
          const SizedBox(width: 12),
          Text(title, style: AppStyles.optionsItem),
        ],
      ),
    );
  }

  /// Sets selected search dictionary.
  void _setSearchDictionary(
    BuildContext context,
    SearchDictionary searchDictionary,
  ) {
    searchBloc.add(SearchDictionarySet(searchDictionary));
    context.submitSearch();
  }

  /// Returns list of all possible dictionary options.
  List<Widget> _buildDictionaryOptions(
    BuildContext context,
    SearchState state,
  ) {
    return SearchDictionary.values
        .map(
          (SearchDictionary dictionary) => _buildOption(
            title: getDictionaryName(dictionary),
            isSelected: dictionary == state.searchDictionary,
            onPressed: () => _setSearchDictionary(context, dictionary),
          ),
        )
        .toList();
  }

  /// Returns 'Contact' button for menu
  Widget _buildContact() {
    return MaterialButton(
      onPressed: () => searchBloc.add(SentFeedbackEmail()),
      child: _buildOptionsTitle(LocaleKeys.contact.tr()),
    );
  }

  Widget _buildUploadImage(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImageScreen()),
        );
      },
      child: _buildOptionsTitle(LocaleKeys.uploadImage.tr()),
    );
  }

  Widget _buildPurchaseSubscription(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.of(context).pop();
        PurchaseProductList.showPurchaseDialog(context);
      },
      child: _buildOptionsTitle(LocaleKeys.removeAdvert.tr()),
    );
  }
}
