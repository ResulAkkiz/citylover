import 'package:citylover/app_contants/image_enums.dart';
import 'package:citylover/app_contants/theme_colors.dart';
import 'package:citylover/models/country_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class LocationDropDownSearch extends StatelessWidget {
  const LocationDropDownSearch(
      {super.key,
      required this.onChanged,
      required this.hintText,
      required this.showSearch,
      required this.selectedItem,
      required this.items,
      required this.enabled});
  final void Function(LocationModel?)? onChanged;
  final String hintText;
  final bool showSearch;
  final List<LocationModel> items;
  final LocationModel? selectedItem;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<LocationModel>(
        enabled: enabled,
        selectedItem: selectedItem,
        itemAsString: (item) {
          return item.name;
        },
        dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: ThemeColors.textGrey200))),
        dropdownButtonProps: DropdownButtonProps(
            color: ThemeColors.primary500,
            icon: const Icon(
              Icons.expand_more_rounded,
              size: 24,
            )),
        popupProps: PopupProps.bottomSheet(
            bottomSheetProps: BottomSheetProps(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width * 0.9),
              backgroundColor: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: ThemeColors.primary300),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10.0),
                ),
              ),
            ),
            emptyBuilder: (context, searchEntry) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AspectRatio(
                      aspectRatio: 2.5,
                      child: Image.asset(
                        ImageEnum.nodata.toPath,
                      )),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Böyle bir yer olduğuna emin misin ?",
                      style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              );
            },
            listViewProps: const ListViewProps(
              physics: BouncingScrollPhysics(),
            ),
            itemBuilder: (context, item, isSelected) {
              return Align(
                alignment: Alignment.center,
                child: Chip(
                  backgroundColor: ThemeColors.background200,
                  label: Text(
                    item.name,
                    style: TextStyle(color: ThemeColors.primary500),
                  ),
                ),
              );
            },
            constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.5),
            searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
              hintText: "Ara...",
              hintStyle:
                  TextStyle(color: ThemeColors.textGrey200, fontSize: 14),
            )),
            searchDelay: const Duration(milliseconds: 100),
            showSearchBox: showSearch,
            scrollbarProps: ScrollbarProps(
                thumbColor: ThemeColors.primary500,
                thickness: 5,
                radius: const Radius.circular(2))),
        items: items,
        onChanged: onChanged);
  }
}
