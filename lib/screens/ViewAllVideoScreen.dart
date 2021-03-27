import 'package:flutter/material.dart';
import 'package:hackeridiot/components/AppWidgets.dart';
import 'package:hackeridiot/components/VideoListWidget.dart';
import 'package:hackeridiot/models/DashboardResponse.dart';
import 'package:hackeridiot/network/RestApis.dart';
import 'package:hackeridiot/utils/Common.dart';
import 'package:hackeridiot/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../AppLocalizations.dart';

class ViewAllVideoScreen extends StatefulWidget {
  static String tag = '/ViewAllVideoScreen';

  @override
  ViewAllVideoScreenState createState() => ViewAllVideoScreenState();
}

class ViewAllVideoScreenState extends State<ViewAllVideoScreen> {
  int page = 1;
  bool isLastPage = false;

  List<VideoData> videos = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setDynamicStatusBarColor();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocale = AppLocalizations.of(context);

    return SafeArea(
top: !isIos,
      child: Scaffold(
        appBar: appBarWidget(appLocale.translate('videos'), showBack: true, color: getAppBarWidgetBackGroundColor(), textColor: getAppBarWidgetTextColor()),
        body: NotificationListener(
          onNotification: (n) {
            if (!isLastPage) {
              if (n is ScrollEndNotification) {
                log(n.metrics.pixels.toInt());

                if (n.metrics.pixels.toInt() == n.metrics.maxScrollExtent) {
                  page++;
                  setState(() {});
                }
              }
            }
            return !isLastPage;
          },
          child: FutureBuilder<List<VideoData>>(
            future: getVideos(page),
            builder: (_, snap) {
              if (snap.hasData) {
                if (page == 1) videos.clear();

                videos.addAll(snap.data.validate());

                isLastPage = snap.data.validate().length != postsPerPage;

                if (snap.data.isNotEmpty) {
                  return VideoListWidget(snap.data, axis: Axis.vertical);
                } else {
                  return noDataWidget(context);
                }
              }

              return snapWidgetHelper(snap);
            },
          ),
        ),
      ),
    );
  }
}
