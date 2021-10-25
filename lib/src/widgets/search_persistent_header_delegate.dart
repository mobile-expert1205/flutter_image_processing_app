import 'dart:math';

import 'package:flutter/material.dart';

/// This class implements delegate to create persistent header into SliverList.
class SearchPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  /// Child to show inside.
  final Widget child;

  /// Maximum height.
  final double expandedHeight;

  /// Minimum height.
  final double collapsedHeight;

  /// Constructor.
  SearchPersistentHeaderDelegate({
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.child,
  });

  /// Describes the part of the user interface represented by this widget.
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  /// Whether this delegate is meaningfully different from the old delegate.
  @override
  bool shouldRebuild(SearchPersistentHeaderDelegate oldDelegate) {
    return expandedHeight != oldDelegate.expandedHeight ||
        collapsedHeight != oldDelegate.collapsedHeight;
  }

  /// The size of the header when it is not shrinking at the top of the
  /// viewport.
  @override
  double get maxExtent => max<double>(expandedHeight, minExtent);

  /// The smallest size to allow the header to reach, when it shrinks at the
  /// start of the viewport.
  @override
  double get minExtent => collapsedHeight;
}
