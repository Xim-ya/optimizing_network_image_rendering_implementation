import 'package:flutter/cupertino.dart';

/** Created By Ximya - 2023.08.08
 * 이미지의 캐시 크기를 계산하는 확장(extension). 이 확장은 주어진 double,int 값에
 * 기반하여 이미지의 크기를 캐시 크기로 변환함.
 * 디바이스의 픽셀 비율을 고려하여 다양한 해상도에서 일관된 화질을 유지합니다.
 *
 * 사용 방법:
 * double imageWidth = 100.0;
 * int cachedWidth = imageWidth.cacheSize(context);
 *
 * int imageHeight = 200;
 * int cachedHeight = imageHeight.cacheSize(context);
 *
 * context 캐시 크기를 계산하는 데 사용되는 BuildContext.
 * 주어진 double,int 값에 디바이스의 픽셀 비율을 곱하고, 가장 가까운 정수로 반올림한 값을 반환합니다.
 *
 *
 * 레퍼런스 : https://github.com/flutter/flutter/issues/56239
 */

Size getAspectRationImgCache(
  BuildContext context, {
  required String imgUrl,
  required double imgAspectRatio,
  required Size targetSize,
}) {
  double cacheWidth, cacheHeight;

  final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

  final double minWidth = devicePixelRatio * targetSize.width; // 최소 넓이
  final double minHeight = devicePixelRatio * targetSize.height; // 최소 높이

  final double targetAspectRatio = targetSize.width / targetSize.height;

  if (targetAspectRatio > imgAspectRatio) {
    // 원본 이미지의 세로를 기준으로 더 높은 해상도를 설정합니다.
    cacheHeight = targetSize.height * devicePixelRatio;
    cacheWidth = (cacheHeight * imgAspectRatio).roundToDouble();
  } else {
    // 원본 이미지의 가로를 기준으로 더 높은 해상도를 설정합니다.
    cacheWidth = targetSize.width * devicePixelRatio;
    cacheHeight = (cacheWidth / imgAspectRatio).roundToDouble();
  }

  // 부족한 높이만큼 추가로 더해줍니다.
  if (cacheHeight < minHeight) {
    final additionalHeight = minHeight - cacheHeight;
    cacheHeight += additionalHeight;
    cacheWidth += additionalHeight * imgAspectRatio;
  }

  // 부족한 넓이만큼 추가로 더해줍니다.
  if (cacheWidth < minWidth) {
    final additionalWidth = minWidth - cacheWidth;
    cacheWidth += additionalWidth;
    cacheHeight += additionalWidth / imgAspectRatio;
  }

  print('최종 width ${cacheWidth} , height ${cacheHeight}');

  return Size(cacheWidth, cacheHeight);
}

extension CachedImgSizeDoubleExtension on double {
  int cacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }
}

extension CachedImgSizeIntExtension on int {
  int cacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }
}
