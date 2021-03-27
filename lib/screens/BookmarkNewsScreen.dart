import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hackeridiot/AppLocalizations.dart';
import 'package:hackeridiot/components/NewsItemWidget.dart';
import 'package:hackeridiot/models/DashboardResponse.dart';
import 'package:hackeridiot/network/RestApis.dart';
import 'package:hackeridiot/screens/NewsDetailListScreen.dart';
import 'package:hackeridiot/utils/Common.dart';
import 'package:hackeridiot/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class BookmarkNewsScreen extends StatefulWidget {
  static String tag = '/BookmarkNewsScreen';

  @override
  BookmarkNewsScreenState createState() => BookmarkNewsScreenState();
}

class BookmarkNewsScreenState extends State<BookmarkNewsScreen> {
  ScrollController scrollController = ScrollController();

  bool isLastPage = false;
  int page = 1;
  int numPage = 1;

  List<NewsData> posts = [];

  @override
  void initState() {
    super.initState();
    init();
    setDynamicStatusBarColor();

    loadNews();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (page < numPage) {
          page++;
          loadNews();
        }
      }
    });
  }

  Future<void> init() async {
    LiveStream().on(refreshBookmark, (v) {
      page = 1;
      posts.clear();
      isLastPage = false;

      setState(() {});
    });
  }

  Future<void> loadNews() async {
    appStore.setLoading(true);

    await getWishList(page).then((value) async {
      appStore.setLoading(false);

      numPage = value.num_pages.validate(value: 1);

      if (page == 1) {
        await setValue(VIEW_ALL_DATA, jsonEncode(value.posts));

        posts.clear();
      }
      posts.addAll(value.posts);

      setState(() {});
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(refreshBookmark);
    scrollController.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context);

    return SafeArea(
top: !isIos,
      child: Scaffold(
        appBar: appBarWidget(appLocalization.translate('Bookmarks'), showBack: true, color: getAppBarWidgetBackGroundColor(), textColor: getAppBarWidgetTextColor()),
        body: Stack(
          children: [
            ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              itemCount: posts.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (_, index) {
                return NewsItemWidget(
                  posts[index],
                  onTap: () {
                    NewsDetailListScreen(posts, index: index).launch(context);
                  },
                );
              },
            ),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
