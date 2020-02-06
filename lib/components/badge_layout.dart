import 'package:flutter/material.dart';
import 'package:flutter_cafclcc/models/fan_badge.dart';
import '../models/constants.dart' as constant;

class BadgeLayout extends StatelessWidget {

  FanBadge fanBadge;
  double scale;

  BadgeLayout(this.fanBadge, {this.scale: 1.0});

  @override
  Widget build(BuildContext context) {
    return Transform(
        transform: new Matrix4.identity()..scale(scale),
      child: Chip(
      avatar: CircleAvatar(
        backgroundColor: Colors.white,
        child: Image.network(fanBadge.url_logo),
      ),
      backgroundColor: constant.fromHex(fanBadge.color),
      label: Text(
        fanBadge.title,
        style: TextStyle(
          color: Colors.white
        ),
      ),
    )
    );
  }

}