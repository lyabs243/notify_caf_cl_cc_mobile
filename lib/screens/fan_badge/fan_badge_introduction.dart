import 'package:flutter/material.dart';

class FanBadgeIntroduction extends StatelessWidget {

  Map localization;

  FanBadgeIntroduction(this.localization);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localization['fan_badge']),
      ),
      body: Container(),
    );
  }

}