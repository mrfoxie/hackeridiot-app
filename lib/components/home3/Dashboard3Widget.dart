import 'package:flutter/material.dart';
import 'package:hackeridiot/components/BreakingNewsMarqueeWidget.dart';
import 'package:hackeridiot/components/CryptoCurrencyListWidget.dart';
import 'package:hackeridiot/components/VideoListWidget.dart';
import 'package:hackeridiot/components/ViewAllHeadingWidget.dart';
import 'package:hackeridiot/components/home3/components/Dashboard3BreakingNewsListWidget.dart';
import 'package:hackeridiot/components/home3/components/Dashboard3NewsListWidget.dart';
import 'package:hackeridiot/models/DashboardResponse.dart';
import 'package:hackeridiot/screens/ViewAllNewsScreen.dart';
import 'package:hackeridiot/screens/ViewAllVideoScreen.dart';
import 'package:hackeridiot/utils/Colors.dart';
import 'package:hackeridiot/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../AppLocalizations.dart';
import '../TwitterFeedListWidget.dart';
import '../ViewAllHeadingWidget.dart';

class Dashboard3Widget extends StatefulWidget {
  final AsyncSnapshot<DashboardResponse> snap;

  Dashboard3Widget(this.snap);

  @override
  Dashboard3WidgetState createState() => Dashboard3WidgetState();
}

class Dashboard3WidgetState extends State<Dashboard3Widget> {
  String mBreakingNewsMarquee = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // setDynamicStatusBarColor();
    widget.snap.data.breaking_post.forEach((element) {
      mBreakingNewsMarquee = mBreakingNewsMarquee + ' | ' + element.post_title;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);

    return Container(
      height: context.height(),
      width: context.width(),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BreakingNewsMarqueeWidget(string: mBreakingNewsMarquee),
            16.height,
            CryptoCurrencyListWidget(),
            16.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ViewAllHeadingWidget(
                  title: appLocalization.translate('breaking_News').toUpperCase(),
                  backgroundColor: white,
                  textColor: scaffoldColorDark,
                  onTap: () {
                    ViewAllNewsScreen(title: 'breaking_News', req: {'posts_per_page': postsPerPage, FILTER: FILTER_FEATURE}).launch(context);
                  },
                ),
                8.height,
                Dashboard3BreakingNewsListWidget(widget.snap.data.breaking_post),
              ],
            ).visible(widget.snap.data.breaking_post.validate().isNotEmpty),
            8.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ViewAllHeadingWidget(
                  title: appLocalization.translate('recent_News').toUpperCase(),
                  textColor: scaffoldColorDark,
                  backgroundColor: white,
                  onTap: () {
                    ViewAllNewsScreen(title: 'recent_News', req: {'posts_per_page': postsPerPage}).launch(context);
                  },
                ),
                8.height,
                Dashboard3NewsListWidget(widget.snap.data.recent_post, padding: EdgeInsets.symmetric(horizontal: 8)),
              ],
            ).visible(widget.snap.data.recent_post.validate().isNotEmpty),
            16.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ViewAllHeadingWidget(
                  title: appLocalization.translate('videos').toUpperCase(),
                  backgroundColor: white,
                  textColor: scaffoldColorDark,
                  onTap: () {
                    ViewAllVideoScreen().launch(context);
                  },
                ),
                8.height,
                VideoListWidget(widget.snap.data.videos.validate(), axis: Axis.horizontal),
              ],
            ).visible(widget.snap.data.videos.validate().isNotEmpty),
            8.height,

            //Show Twitter Widget only if you have not disabled in your Word-Press Admin panel
            getBoolAsync(DISABLE_TWITTER_WIDGET) ? SizedBox() : TwitterFeedListWidget(),
          ],
        ),
      ),
    );
  }
}
