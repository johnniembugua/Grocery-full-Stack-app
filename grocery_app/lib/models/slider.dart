import 'package:freezed_annotation/freezed_annotation.dart';

import '../config.dart';
part 'slider.freezed.dart';
part 'slider.g.dart';

List<SliderModel> slidersFromJson(dynamic str) =>
    List<SliderModel>.from((str).map((e) => SliderModel.fromJson(e)));

@freezed
abstract class SliderModel implements _$SliderModel {
  factory SliderModel({
    required String sliderId,
    required String sliderName,
    required String sliderImage,
  }) = _Slider;

  factory SliderModel.fromJson(Map<String, dynamic> json) =>
      _$SliderModelFromJson(json);
}

extension SliderModelExt on SliderModel {
  String get fullImagePath => Config.imageURL + sliderImage;
}
