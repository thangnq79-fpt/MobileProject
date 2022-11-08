import 'package:flutter/material.dart';
import 'package:tesma/constants/break_point.dart';

class ReponsiveLayout extends StatelessWidget {
  const ReponsiveLayout({
    Key key,
    @required this.mobileBody,
    this.tabletBody,
    this.desktopBody,
  }) : super(key: key);

  final Widget mobileBody;
  final Widget tabletBody;
  final Widget desktopBody;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, dimens) {
      if (dimens.maxWidth < kTableBreakPoint) {
        return mobileBody;
      } else if (dimens.maxWidth >= kTableBreakPoint &&
          dimens.maxWidth < kDesktopBreakPoint) {
        return tabletBody ?? mobileBody;
      } else {
        return desktopBody ?? mobileBody;
      }
    });
  }
}
