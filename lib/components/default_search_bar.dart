import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:movie_time/utilities/constants.dart';

class DefaultSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final Function? onChanged;
  final Function? onPressed;
  const DefaultSearchBar({
    super.key,
    @required this.controller,
    @required this.focusNode,
    this.hintText,
    @required this.onChanged,
    @required this.onPressed,
  });

  @override
  State<DefaultSearchBar> createState() => _DefaultSearchBarState();
}

class _DefaultSearchBarState extends State<DefaultSearchBar> {
  bool dark = false;

  @override
  Widget build(BuildContext context) {
    dark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: SearchBar(
        backgroundColor:
            MaterialStateProperty.all(dark ? bgColorDark3 : bgColorLight2),
        controller: widget.controller,
        focusNode: widget.focusNode,
        hintText: widget.hintText ?? 'Search...',
        leading: Icon(
          Icons.search,
          color: widget.controller!.text.isNotEmpty
              ? (dark ? whiteColor : blackColor)
              : mutedColor,
        ),
        trailing: widget.controller!.text.isNotEmpty
            ? [
                IconButton(
                  onPressed: () => widget.onPressed!(),
                  tooltip: 'Clear',
                  icon: Icon(
                    Icons.clear,
                    color: widget.controller!.text.isNotEmpty
                        ? (dark ? whiteColor : blackColor)
                        : mutedColor,
                  ),
                ),
              ]
            : null,
        onChanged: (value) => widget.onChanged!(value),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.focused)) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(defaultRadius),
              ),
              side: BorderSide(color: primaryColor),
            );
          }
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(defaultRadius),
            ),
            side: BorderSide.none,
          );
        }),
        hintStyle: MaterialStateProperty.all(
          TextStyle(
            color: mutedColor,
          ),
        ),
        textStyle: MaterialStateProperty.all(
          TextStyle(
            color: (dark ? whiteColor : blackColor),
          ),
        ),
      ),
    );
  }
}
