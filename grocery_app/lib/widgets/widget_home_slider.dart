import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/models/pagination.dart';
import 'package:grocery_app/models/slider.dart';
import 'package:grocery_app/providers.dart';

class HomeSliderWidget extends ConsumerWidget {
  const HomeSliderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      child: _sliderList(ref),
    );
  }

  Widget _sliderList(WidgetRef ref) {
    final sliders =
        ref.watch(slidersProvider(PaginationModel(page: 1, pageSize: 10)));

    return sliders.when(data: (data) {
      return imageCarousel(data!);
    }, error: (error, stacktrace) {
      return const Center(
        child: Text("Error occurred"),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget imageCarousel(
    List<SliderModel> sliderList,
  ) {
    return CarouselSlider(
        items: sliderList.map((model) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(model.fullImagePath),
                fit: BoxFit.contain,
              ),
            ),
          );
        }).toList(),
        options: CarouselOptions(
          enableInfiniteScroll: true,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.decelerate,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.8,
        ));
  }
}
