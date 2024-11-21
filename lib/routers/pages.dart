

import 'package:comic/initPage.binding.dart';
import 'package:comic/initPage.dart';
import 'package:get/get.dart';

import '../pages/index.dart';
import 'names.dart';

class RoutePages {

  static List<GetPage> getPage = [
    GetPage(
      name: RouteNames.initPage,
      page: () => const InitPage(),
      binding: InitPageBinding(),
    ),
    GetPage(
      name: RouteNames.home,
      page: () => const HomePage(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: RouteNames.mine,
      page: () => const MinePage(),
      binding: MinePageBinding(),
    ),
    GetPage(
      name: RouteNames.comicItemPage,
      page: () => const ComicItemPage(),
      binding: ComicItemPageBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RouteNames.comicItem18Page,
      page: () => const Comic18ItemPage(),
      binding: ComicItem18PageBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RouteNames.comicReaderPage,
      page: () => const ComicReaderPage(),
      binding: ComicReaderPageBinding(),
    ),
    GetPage(
      name: RouteNames.searchPage,
      page: () => const SearchPage(),
      binding: SearchPageBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RouteNames.loginPage,
      page: () => const LoginPage(),
      binding: LoginPageBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}