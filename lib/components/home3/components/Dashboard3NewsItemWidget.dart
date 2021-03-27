import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hackeridiot/components/AppWidgets.dart';
import 'package:hackeridiot/main.dart';
import 'package:hackeridiot/models/DashboardResponse.dart';
import 'package:hackeridiot/screens/NewsDetailScreen.dart';
import 'package:hackeridiot/utils/Colors.dart';
import 'package:hackeridiot/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class Dashboard3NewsItemWidget extends StatefulWidget {
  static String tag = '/Dashboard3NewsItemWidget';

  final NewsData newsData;
  final Function onTap;

  Dashboard3NewsItemWidget(this.newsData, {this.onTap});

  @override
  Dashboard3NewsItemWidgetState createState() => Dashboard3NewsItemWidgetState();
}

class Dashboard3NewsItemWidgetState extends State<Dashboard3NewsItemWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //setDynamicStatusBarColor();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    String heroTag = '${widget.newsData.iD}${currentTimeStamp()}';

    return Container(
      margin: EdgeInsets.all(8),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: appStore.isDarkMode ? scaffoldColorDark : white,
        borderRadius: radius(),
        boxShadow: defaultBoxShadow(blurRadius: 100.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cachedImage(
                widget.newsData.image.validate(),
                width: 130,
                height: 132,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRectOnly(topLeft: 8, bottomLeft: 8),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.height,
                  Text(
                    parseHtmlString(widget.newsData.post_title.validate()),
                    maxLines: 2,
                    style: boldTextStyle(size: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  8.height,
                  Text(
                    parseHtmlString(widget.newsData.post_content.validate()),
                    maxLines: 2,
                    style: primaryTextStyle(size: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  8.height,
                  Align(
                    child: Text(widget.newsData.readable_date.validate(), maxLines: 1, style: secondaryTextStyle(size: 12)),
                    alignment: Alignment.centerLeft,
                  ),
                  8.height,
                ],
              ).expand(),
            ],
          ),
        ],
      ),
    ).onTap(() {
      widget.onTap?.call();
      //NewsDetailScreen(newsData: widget.newsData, heroTag: heroTag).launch(context);
    });
  }
}
