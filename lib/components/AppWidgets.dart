import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hackeridiot/AppLocalizations.dart';
import 'package:hackeridiot/models/LanguageModel.dart';
import 'package:hackeridiot/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';

import '../main.dart';

Widget cachedImage(String url, {double height, double width, BoxFit fit, AlignmentGeometry alignment, bool usePlaceholderIfUrlEmpty = true, double radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.asset(url, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({double height, double width, BoxFit fit, AlignmentGeometry alignment, double radius}) {
  return Image.asset('assets/placeholder.jpg', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

Widget noDataWidget(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Image.asset('assets/no_data.png', height: 80, fit: BoxFit.fitHeight),
      8.height,
      Text(AppLocalizations.of(context).translate('no_data'), style: boldTextStyle()).center(),
    ],
  ).center();
}

Widget languageSelectionWidget(BuildContext context) {
  var appLocalization = AppLocalizations.of(context);

  return SettingItemWidget(
    leading: Image.asset(language.flag, height: 24),
    title: 'Language',
    subTitle: appLocalization.translate('choose_app_language'),
    onTap: () async {
      hideKeyboard(context);
    },
    trailing: DropdownButton(
      items: languages.map((e) => DropdownMenuItem<Language>(child: Text(e.name, style: primaryTextStyle(size: 14)), value: e)).toList(),
      dropdownColor: appStore.isDarkMode ? scaffoldSecondaryDark : Colors.white,
      value: language,
      underline: SizedBox(),
      onChanged: (Language v) async {
        hideKeyboard(context);
        appStore.setLanguage(v.languageCode);
      },
    ),
  );
}

void openPhotoViewer(BuildContext context, ImageProvider imageProvider) {
  Scaffold(
    body: Stack(
      children: <Widget>[
        PhotoView(
          imageProvider: imageProvider,
          minScale: PhotoViewComputedScale.contained,
          maxScale: 1.0,
        ),
        Positioned(top: 35, left: 16, child: BackButton(color: Colors.white)),
      ],
    ),
  ).launch(context);
}
