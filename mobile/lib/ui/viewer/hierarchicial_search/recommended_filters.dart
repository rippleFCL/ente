import "package:flutter/material.dart";
import "package:photos/models/search/hierarchical/face_filter.dart";
import "package:photos/models/search/hierarchical/hierarchical_search_filter.dart";
import "package:photos/ui/viewer/gallery/state/inherited_search_filter_data.dart";
import "package:photos/ui/viewer/gallery/state/search_filter_data_provider.dart";
import "package:photos/ui/viewer/hierarchicial_search/filter_chip.dart";

class RecommendedFilters extends StatefulWidget {
  const RecommendedFilters({super.key});

  @override
  State<RecommendedFilters> createState() => _RecommendedFiltersState();
}

class _RecommendedFiltersState extends State<RecommendedFilters> {
  late SearchFilterDataProvider _searchFilterDataProvider;
  late List<HierarchicalSearchFilter> _recommendations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final inheritedSearchFilterData = InheritedSearchFilterData.of(context);
    assert(
      inheritedSearchFilterData.isHierarchicalSearchable,
      "Do not use this widget if gallery is not hierarchical searchable",
    );
    _searchFilterDataProvider =
        inheritedSearchFilterData.searchFilterDataProvider!;
    _recommendations = _searchFilterDataProvider.recommendations;

    _searchFilterDataProvider.removeListener(
      fromRecommended: true,
      listener: onRecommendedFiltersUpdate,
    );
    _searchFilterDataProvider.addListener(
      toRecommended: true,
      listener: onRecommendedFiltersUpdate,
    );
  }

  @override
  void dispose() {
    _searchFilterDataProvider.removeListener(
      fromRecommended: true,
      listener: onRecommendedFiltersUpdate,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final filter = _recommendations[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: filter is FaceFilter
              ? FaceFilterChip(
                  personId: filter.personId,
                  clusterId: filter.clusterId,
                  faceThumbnailFile: filter.faceFile,
                  name: filter.name(),
                  onTap: () {
                    _searchFilterDataProvider.applyFilters([filter]);
                  },
                )
              : GenericFilterChip(
                  label: filter.name(),
                  onTap: () {
                    _searchFilterDataProvider.applyFilters([filter]);
                  },
                  leadingIcon: filter.icon(),
                ),
        );
      },
      scrollDirection: Axis.horizontal,
      itemCount: _recommendations.length,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  void onRecommendedFiltersUpdate() {
    setState(() {
      _recommendations = _searchFilterDataProvider.recommendations;
    });
  }
}