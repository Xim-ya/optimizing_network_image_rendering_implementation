import 'package:flutter/cupertino.dart';

extension ImageCacheSizeNum on num {
  int cacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }
}
