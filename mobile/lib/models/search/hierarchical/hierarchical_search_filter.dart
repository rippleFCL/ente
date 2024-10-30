import "package:flutter/widgets.dart";
import "package:photos/models/file/file.dart";

int kMostRelevantFilter = 10000;
int kLeastRelevantFilter = -1;

enum FilterTypeNames {
  albumFilter,
  contactsFilter,
  faceFilter,
  fileTypeFilter,
  locationFilter,
  magicFilter,
  topLevelGenericFilter,
  onlyThemFilter,
}

abstract class HierarchicalSearchFilter {
  //These matches should be from list of all files in db and not just all files
  //in gallery since this is used as cache for faster filtering when
  //adding/removing applied filters. An exception where results can be all files
  //in gallery is when the filter is the initial filter (top level) of the
  //gallery.
  final String filterTypeName;
  final Set<int> matchedUploadedIDs;
  bool isApplied = false;

  HierarchicalSearchFilter({required this.filterTypeName, matchedUploadedIDs})
      : matchedUploadedIDs = matchedUploadedIDs ?? {},
        assert(
          FilterTypeNames.values
              .map((e) => e.toString().split(".").last)
              .contains(filterTypeName),
          "filterTypeName = $filterTypeName is not a valid filter type in FilterTypeNames enum. Please add it to the enum if it's missing or else, cross check spelling ",
        );

  String name();
  IconData? icon();

  /// Will be [kmostRelevantFilter] if the filter is a Top-levl filter. For
  /// example, when searching for an album 'A' and opening it, when
  /// hierarchical search starts, the album 'A' will be the top level filter.
  int relevance();
  bool isMatch(EnteFile file);
  Set<int> getMatchedUploadedIDs();
  bool isSameFilter(HierarchicalSearchFilter other);
}