import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:wordfinderx/generated/locale_keys.g.dart';
import 'package:wordfinderx/src/blocs/device_type_and_orientation/device_type_and_orientation.dart';
import 'package:wordfinderx/src/blocs/input/input_bloc.dart';
import 'package:wordfinderx/src/blocs/purchase/purchase_bloc.dart';
import 'package:wordfinderx/src/blocs/search/search.dart';
import 'package:wordfinderx/src/blocs/word_page/word_page.dart';
import 'package:wordfinderx/src/common/app_colors.dart';
import 'package:wordfinderx/src/common/app_styles.dart';
import 'package:wordfinderx/src/models/device_type_and_orientation_model.dart';
import 'package:wordfinderx/src/models/search_result_model.dart';
import 'package:wordfinderx/src/models/word_page_model.dart';
import 'package:wordfinderx/src/widgets/app_bar_widget.dart';
import 'package:wordfinderx/src/widgets/end_drawer_button.dart';
import 'package:wordfinderx/src/widgets/custom_keyboard/custom_keyboard_actions_config_mixin.dart';
import 'package:wordfinderx/src/widgets/playable_word.dart';
import 'package:wordfinderx/src/widgets/purchase/advert_card.dart';
import 'package:wordfinderx/src/widgets/scroll_up_button/scroll_up_button_overlay.dart';
import 'package:wordfinderx/src/widgets/search_persistent_header_delegate.dart';
import 'package:wordfinderx/src/widgets/sliver_to_box_adapter_filled.dart';
import 'package:wordfinderx/src/widgets/sliver_word_card.dart';
import 'package:easy_localization/easy_localization.dart';

import '../blocs/search/search.dart';
import '../common/app_colors.dart';
import 'common.dart';
import 'dictionary_first_start_selector/dictionary_selector_list.dart';
import 'logo.dart';
import 'search_options/group_by_check_box.dart';
import 'search_options/search_options.dart';
import 'search_options/search_options_wrapper.dart';

/// This class implements search screen with obtained results, or empty stub
/// if there are no results.
class SearchResult extends StatefulWidget {
  /// Instance of BLoC to interact with.
  final SearchBloc _searchBloc;

  final DeviceTypeAndOrientationBloc _deviceTypeAndOrientationBloc;

  /// Constructor.
  const SearchResult(
      {Key? key,
      required SearchBloc searchBloc,
      required DeviceTypeAndOrientationBloc deviceTypeAndOrientationBloc})
      : _searchBloc = searchBloc,
        _deviceTypeAndOrientationBloc = deviceTypeAndOrientationBloc,
        super(key: key);

  /// Returns state object for this widget.
  @override
  _SearchResultState createState() => _SearchResultState();
}

/// Class implements state for this widget.
class _SearchResultState extends State<SearchResult>
    with CustomKeyboardActionsConfigMixin {
  bool _wereValuesInitialised = false;

  /// Fixed height of logo panel.
  // static const double _logoPanelHeightInit = 30.0;
  // double _logoPanelHeight;

  /// Fixed height of letters panel.
  static const double _lettersPanelHeightInit = 60.0;
  double _lettersPanelHeight = _lettersPanelHeightInit;

  /// Fixed height of advanced panel.
  static const double _advancedPanelCollapsedHeightInit = 80;
  double _advancedPanelCollapsedHeight = _advancedPanelCollapsedHeightInit;

  /// Fixed app bar panel.
  static const double _appBarHeightInit = 30.0;
  double _appBarHeight = _appBarHeightInit;

  /// Fixed app bar panel for tablet.
  static const double _appBarHeightTabletInit = 45.0;
  double _appBarHeightTablet = _appBarHeightTabletInit;

  /// Fixed height of card title.
  static const double _cardTitleHeightInit = 40.0;
  double _cardTitleHeight = _cardTitleHeightInit;

  /// Fixed height of search panel divider.
  static const double _searchPanelDividerHeightInit = 1.0;
  double _searchPanelDividerHeight = _searchPanelDividerHeightInit;

  static const double _scrollUpButtonBottom = 10.0;

  static const double _scrollUpButtonRight = 10.0;

  /// Map of BLoCs for each words page.
  Map<int, WordPageBloc> _blocs = {};

  /// Result of search.
  SearchResultModel? _searchResultModel;

  /// Scroll controller to manage position of scroll list.
  ScrollController? _scrollController;

  /// Sliver app bar instance to obtain its height.
  SliverAppBar? _sliverAppBar;

  double _initialScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    lettersActionsItemConfig.focusNode.addListener(_lettersInputFocusListener);
  }

  void _lettersInputFocusListener() {
    if ((_scrollController?.hasClients ?? false) &&
        lettersActionsItemConfig.focusNode.hasFocus) {
      _scrollController?.jumpTo(0);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initValues();
  }

  void _initValues() {
    if (!_wereValuesInitialised) {
      _wereValuesInitialised = true;

      final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

      final int lettersPanelHeightDp =
          (_lettersPanelHeightInit * devicePixelRatio).toInt();
      _lettersPanelHeight = lettersPanelHeightDp / devicePixelRatio;

      final int advancedPanelCollapsedHeightDp =
          (_advancedPanelCollapsedHeightInit * devicePixelRatio).toInt();
      _advancedPanelCollapsedHeight =
          advancedPanelCollapsedHeightDp / devicePixelRatio;

      final int appBarHeightDp = (_appBarHeightInit * devicePixelRatio).toInt();
      _appBarHeight = appBarHeightDp / devicePixelRatio;

      final int appBarHeightTabletDp =
          (_appBarHeightTabletInit * devicePixelRatio).toInt();
      _appBarHeightTablet = appBarHeightTabletDp / devicePixelRatio;

      final int cardTitleHeightDp =
          (_cardTitleHeightInit * devicePixelRatio).toInt();
      _cardTitleHeight = cardTitleHeightDp / devicePixelRatio;

      final int searchPanelDividerHeightInitDp =
          (_searchPanelDividerHeightInit * devicePixelRatio).toInt();
      _searchPanelDividerHeight =
          searchPanelDividerHeightInitDp / devicePixelRatio;

      _scrollController?.dispose();

      final DeviceTypeAndOrientationState deviceState =
          widget._deviceTypeAndOrientationBloc.state;

      if (deviceState is DeviceTypeAndOrientationKnownState &&
          deviceState.deviceTypeAndOrientation.isPhone) {
        bool isAdvancedExpanded =
            widget._searchBloc.state.isAdvancedOnResultExpanded;

        _initialScrollOffset = _appBarHeight +
            135 +
            MediaQuery.of(context).viewPadding.top +
            (isAdvancedExpanded ? 160 : 0);

        _scrollController = ScrollController(
          initialScrollOffset: _initialScrollOffset,
          keepScrollOffset: false,
        );
      } else {
        _initialScrollOffset = 0;
        _scrollController = ScrollController();
      }
    }
  }

  /// Describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceTypeAndOrientationBloc,
        DeviceTypeAndOrientationState>(
      bloc: widget._deviceTypeAndOrientationBloc,
      builder: (BuildContext ctx, DeviceTypeAndOrientationState state) {
        if (state is DeviceTypeAndOrientationKnownState) {
          if (state.deviceTypeAndOrientation.deviceType == MyDeviceType.phone) {
            _buildSliverAppBar(MyDeviceType.phone);
            return _buildResult(
              ctx,
              isTopNotch: state.deviceTypeAndOrientation.isTopNotch,
              bottomPadding: state.deviceTypeAndOrientation.bottomPadding,
            );
          }
          _buildSliverAppBar(MyDeviceType.tablet);
          return _buildTablet(ctx, state);
        }
        return Container();
      },
    );
  }

  Widget _buildResult(
    BuildContext context, {
    bool showOnlyResults = false,
    bool isTopNotch = false,
    double bottomPadding = 0,
  }) {
    return ScrollUpButtonOverlay(
      right: _scrollUpButtonRight,
      bottom: _scrollUpButtonBottom + bottomPadding,
      scrollController: _scrollController ?? ScrollController(),
      child: BlocConsumer<SearchBloc, SearchState>(
        bloc: widget._searchBloc,
        buildWhen: _buildWhen,
        listener: _wordPageSortTypeListener,
        listenWhen: _wordPageSortTypeListenWhen,
        builder: (BuildContext ctx, SearchState searchState) {
          return _buildResultList(
            ctx,
            searchState,
            showOnlyResults: showOnlyResults,
            isTopNotch: isTopNotch,
          );
        },
      ),
    );
  }

  bool _wordPageSortTypeListenWhen(SearchState previous, SearchState current) =>
      previous.wordPageSortType != current.wordPageSortType;

  void _wordPageSortTypeListener(BuildContext context, SearchState state) {
    if (_blocs.isNotEmpty) {
      final WordPageSortTypeChanged event = getWordPageSortTypeChangedEvent(
        context,
        state.wordPageSortType,
      );
      _blocs.forEach((key, bloc) => bloc.add(event));
    }
  }

  /// Determines when the widget should be rebuilt.
  bool _buildWhen(SearchState previous, SearchState current) {
    return previous.searchResultModel != current.searchResultModel ||
        previous.resultPresentState != current.resultPresentState;
  }

  /// Builds list of all content.
  Widget _buildResultList(
    BuildContext context,
    SearchState searchState, {
    bool showOnlyResults = false,
    bool isTopNotch = false,
  }) {
    final List<Widget> resultSlivers = _buildResultSlivers(
      context,
      searchState,
      isRoundedWordCard: showOnlyResults,
      theme: showOnlyResults ? ApplicationTheme.light : ApplicationTheme.dark,
      showOnlyResults: showOnlyResults,
    );

    final Widget resultList = CustomScrollView(
      controller: _scrollController,
      key: ValueKey(searchState.hashCode),
      slivers: [
        if (!showOnlyResults) _sliverAppBar!,
        if (!showOnlyResults) _buildSliverSearchPanel(),
        if (!showOnlyResults) _buildAdvancedSearchPanel(),
        if (searchState.isCurrentDictMatches)
          _buildPlayableWordPanel(searchState),
        if (!showOnlyResults && searchState.isResultPresent)
          _buildSearchOptionsDivider(),
        ...resultSlivers,
      ],
    );

    if (showOnlyResults) {
      if (searchState.resultPresentState == ResultPresentState.resultPresents) {
        return resultList;
      }

      return _buildEmptyStub(theme: ApplicationTheme.light);
    }

    final Color bgColor =
        searchState.resultPresentState == ResultPresentState.resultPresents
            ? AppColors.secondaryColor
            : AppColors.backgroundColor;

    return GestureDetector(
      onTap: () => BlocProvider.of<InputBloc>(context).add(UnFocusRequested()),
      child: SafeArea(
        top: false,
        child: Container(
          color: bgColor,
          child: KeyboardActions(
            config: keyboardActionsConfig!,
            child: resultList,
          ),
        ),
      ),
    );
  }

  Widget _buildTablet(
    BuildContext context,
    DeviceTypeAndOrientationKnownState state,
  ) {
    return GestureDetector(
      onTap: () => BlocProvider.of<InputBloc>(context).add(UnFocusRequested()),
      child: Container(
        color: AppColors.secondaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height:
                  _appBarHeightTablet + MediaQuery.of(context).viewPadding.top,
              child: CustomScrollView(slivers: [_sliverAppBar!]),
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: state.wordPanelWidth,
                    height: double.infinity,
                    padding: EdgeInsets.only(
                      left: state.wordPanelLeftPadding,
                      top: 8.0,
                    ),
                    child: _buildResult(context, showOnlyResults: true),
                  ),
                  Container(
                    width: state.searchPanelWidth,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Container(
                        child: KeyboardActions(
                          config: keyboardActionsConfig!,
                          child: CustomScrollView(
                            controller: ScrollController(),
                            slivers: [
                              _buildSearchFieldForTablet(),
                              _buildSearchOptionsForTablet(),
                              _buildGroupByLengthForTablet(),
                              _buildDictionaryForTablet(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFieldForTablet() {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: SearchPersistentHeaderDelegate(
        collapsedHeight: 70,
        expandedHeight: 70,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 12.0,
          ),
          child: buildSearchField(
            widget._searchBloc,
            theme: ApplicationTheme.light,
          ),
        ),
      ),
    );
  }

  Widget _buildDictionaryForTablet() {
    return SliverToBoxAdapter(
      child: SearchOptionsWrapper(
        theme: ApplicationTheme.light,
        showActionButton: false,
        collapsable: false,
        title: LocaleKeys.dictionary.tr(),
        titleTextStyle: AppStyles.sortFormTitle,
        child: DictionarySelectorList(
          onTap: () => context.submitSearch(),
        ),
      ),
    );
  }

  Widget _buildSearchOptionsForTablet() {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: SearchPersistentHeaderDelegate(
        collapsedHeight: 252,
        expandedHeight: 252,
        child: Container(
          color: AppColors.secondaryColor,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SearchOptions(
              theme: ApplicationTheme.light,
              actionButtonWidth: 160,
              collapsable: false,
              searchBloc: widget._searchBloc,
              startsWithActionsItemConfig: startsWithActionsItemConfig,
              endsWithActionsItemConfig: endsWithActionsItemConfig,
              containsActionsItemConfig: containsActionsItemConfig,
              lengthActionsItemConfig: lengthActionsItemConfig,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupByLengthForTablet() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: AppColors.greyColor)),
          child: GroupByCheckBox(
            strokeWidth: 2.0,
            boxSize: 24.0,
            theme: GroupByCheckBoxTheme.dark,
            textStyle: AppStyles.dictionarySelectorItem,
            containerPadding: const EdgeInsets.only(
              top: 12.0,
              bottom: 12.0,
              left: 30.0,
              right: 8.0,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds AppBar.
  void _buildSliverAppBar(MyDeviceType type) {
    _sliverAppBar ??= SliverAppBar(
      toolbarHeight:
          type == MyDeviceType.phone ? _appBarHeight : _appBarHeightTablet,
      automaticallyImplyLeading: false,
      leading: LogoAppBarWidget(onTap: _showScreenWithoutResults),
      title: type == MyDeviceType.phone ? Logo() : null,
      pinned: false,
      elevation: 0,
      actions: [EndDrawerButton()],
    );
  }

  void _showScreenWithoutResults() {
    BlocProvider.of<SearchBloc>(context).add(BackToSearchWithoutResults());
  }

  /// Builds list with results.
  List<Widget> _buildResultSlivers(
    BuildContext context,
    SearchState state, {
    bool? isRoundedWordCard,
    ApplicationTheme? theme,
    bool showOnlyResults = false,
  }) {
    List<Widget> slivers = <Widget>[];

    slivers.add(SliverToBoxAdapter(child: AdvertCard()));
    if (state.resultPresentState == ResultPresentState.resultPresents) {
      _createBlocs(context, state);
      slivers.addAll(
        _buildWordPagesSlivers(
          state,
          isRoundedWordCard: isRoundedWordCard,
          theme: theme,
        ),
      );
      if (!showOnlyResults) {
        slivers.add(
          SliverToBoxAdapterFilled(
            additionalExtent: _initialScrollOffset,
            child: Container(
              color: (theme?.isDark ?? true)
                  ? AppColors.backgroundColor
                  : AppColors.secondaryColor,
            ),
          ),
        );
      }
    } else {
      slivers.add(
        SliverToBoxAdapterFilled(
          additionalExtent: _initialScrollOffset,
          child: _buildEmptyStub(),
        ),
      );
    }
    return slivers;
  }

  /// Builds main search panel with letters input field.
  Widget _buildSliverSearchPanel() {
    final double topPadding = MediaQuery.of(context).viewPadding.top;

    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: SearchPersistentHeaderDelegate(
        collapsedHeight: _lettersPanelHeight + topPadding,
        expandedHeight: _lettersPanelHeight + topPadding,
        child: SizedBox(
          height: _lettersPanelHeight + topPadding,
          child: Container(
            color: AppColors.backgroundColor,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 8.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildSearchField(widget._searchBloc),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchOptionsDivider() {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: SearchPersistentHeaderDelegate(
        collapsedHeight: _searchPanelDividerHeight,
        expandedHeight: _searchPanelDividerHeight,
        child: Container(
          height: _searchPanelDividerHeight,
          width: double.infinity,
          color: AppColors.secondaryColor,
        ),
      ),
    );
  }

  /// Build advanced options search panel.
  Widget _buildAdvancedSearchPanel() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(bottom: 4.0, left: 16.0, right: 16.0),
        decoration: BoxDecoration(color: AppColors.backgroundColor),
        child: buildSearchOptions(
          widget._searchBloc,
          collapsable: true,
          showOptionsPanel: true,
          collapsedHeight: _advancedPanelCollapsedHeight,
        ),
      ),
    );
  }

  /// Build panel if letters matches in current dictionary.
  Widget _buildPlayableWordPanel(SearchState state) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: PlayableWord(
          points: state.pointsInCurrentDict,
          searchDictionary: state.searchDictionary,
          word: state.searchResultModel!.request.letters,
        ),
      ),
    );
  }

  /// Builds word pages list.
  List<Widget> _buildWordPagesSlivers(
    SearchState state, {
    bool? isRoundedWordCard,
    ApplicationTheme? theme,
  }) {
    final List<Widget> slivers = state.searchResultModel?.wordPages
            .map(
              (WordPageModel pageModel) => BlocProvider<WordPageBloc>(
                key: UniqueKey(),
                create: (_) => _blocs[pageModel.length]!,
                child: SliverWordCard(
                  theme: theme,
                  isRounded: isRoundedWordCard,
                  titleHeight: _cardTitleHeight,
                  key: UniqueKey(),
                ),
              ),
            )
            .toList() ??
        [];
    return slivers;
  }

  /// Creates map of BLoCs for each word page based on given results.
  void _createBlocs(BuildContext context, SearchState state) {
    if (_searchResultModel != state.searchResultModel) {
      _searchResultModel = state.searchResultModel;
      _blocs = {};
      state.searchResultModel!.wordPages.forEach((pageModel) {
        _blocs[pageModel.length] = WordPageBloc(
          request: state.searchResultModel!.request,
          wordPageModel: pageModel,
          repository: state.repository,
          searchBloc: widget._searchBloc,
          purchaseBloc: BlocProvider.of<PurchaseBloc>(context),
        );
      });
    } else {
      Map<int, WordPageBloc> newBlocs = {};
      state.searchResultModel!.wordPages.forEach((pageModel) {
        newBlocs[pageModel.length] = WordPageBloc(
          request: _blocs[pageModel.length]!.state.request,
          wordPageModel: _blocs[pageModel.length]!.state.wordPageModel,
          repository: state.repository,
          searchBloc: widget._searchBloc,
          purchaseBloc: BlocProvider.of<PurchaseBloc>(context),
        );
      });
      _blocs = newBlocs;
    }
  }

  /// Builds empty stub when no results were fetched.
  Widget _buildEmptyStub({ApplicationTheme? theme}) {
    theme ??= ApplicationTheme.dark;
    return Container(
      color:
          theme.isDark ? AppColors.backgroundColor : AppColors.secondaryColor,
      child: Center(
        child: Text(
          LocaleKeys.noWordsFound.tr(),
          style: theme.isDark
              ? AppStyles.noWordsFound
              : AppStyles.noWordsFoundLightTheme,
        ),
      ),
    );
  }

  /// Disposes scroll controller.
  @override
  void dispose() {
    lettersActionsItemConfig.focusNode
        .removeListener(_lettersInputFocusListener);
    _scrollController?.dispose();
    super.dispose();
  }
}
