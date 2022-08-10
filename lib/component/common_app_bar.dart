import 'package:flutter/material.dart';
import '../constant/telliot_colors.dart';

class CommonAppBar extends StatelessWidget with PreferredSizeWidget {
  final Color backgroundColor;
  final List<Widget> customChild;
  final double height;
  final String title;
  final Color titleColor;
  final Future<void> Function() checkFunction;
  final bool blockBack;

  CommonAppBar({
    this.backgroundColor = TelliotColors.white,
    this.customChild,
    this.height = 48,
    this.title,
    this.titleColor = TelliotColors.white,
    this.checkFunction,
    this.blockBack = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: AppBar(
        leadingWidth: 34,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: Navigator.canPop(context) && !blockBack ? true : false,
        backgroundColor: backgroundColor,
        leading: Navigator.canPop(context) && !blockBack
            ? GestureDetector(
                onTap: () async {
                  if (checkFunction != null) {
                    checkFunction();
                    return;
                  }
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'assets/icon/caret_left.png',
                  scale: 3,
                  color: TelliotColors.black,
                ),
              )
            : null,
        title: title != null
            ? Text(
                title,
                style: TextStyle(
                    color: titleColor,
                    fontSize: 24,
                    height: 28.13 / 24,
                    fontWeight: FontWeight.bold),
              )
            : null,
        actions: [
          if (Navigator.canPop(context))
            SizedBox(
              width: 34,
            ),
          SizedBox(
            width: 2,
          ),
          if (customChild != null) ...customChild,
        ],
      ),
      preferredSize: preferredSize,
    );
  }
}
