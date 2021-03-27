import 'package:flutter/material.dart';
import 'package:hackeridiot/components/VideoItemWidget.dart';
import 'package:hackeridiot/models/DashboardResponse.dart';
import 'package:hackeridiot/utils/Common.dart';

class VideoListWidget extends StatefulWidget {
  static String tag = '/VideoListWidget';
  final List<VideoData> videos;
  final Axis axis;

  VideoListWidget(this.videos, {this.axis = Axis.horizontal});

  @override
  _VideoListWidgetState createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.axis == Axis.vertical) {
      return GridView.builder(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: widget.axis,
        itemBuilder: (_, index) {
          return VideoItemWidget(widget.videos[index], widget.axis);
        },
        itemCount: widget.videos.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      );
    } else {
      return Container(
        height: getDashBoard2WidgetHeight(),
        child: ListView.builder(
          padding: EdgeInsets.only(left: 8, right: 8),
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: widget.axis,
          itemBuilder: (_, index) {
            return VideoItemWidget(widget.videos[index], widget.axis);
          },
          itemCount: widget.videos.length,
          shrinkWrap: true,
        ),
      );
    }
  }
}
