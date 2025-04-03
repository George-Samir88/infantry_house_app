import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infantry_house_app/views/widgets/food_and_beverage_view/food_and_beverage_view.dart';
import 'package:infantry_house_app/views/widgets_2/reservation_view/reservation_view.dart';

import '../../../../generated/l10n.dart';
import '../../activities_view/activities_view_body.dart';
import '../../housing_view/housing_view.dart';
import '../../washing_view/washing_view_body.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  late final GlobalKey<ScaffoldState> scaffoldKey;

  HomeCubit() : super(HomeInitial()) {
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  Map<String, Widget> drawerItemsAndScreensMap = {};
  String selectedAppBarTitle = '';
  Widget selectedScreen = FoodAndBeverageView();

  void initializeDrawerItemsAndScreensMap({required BuildContext context}) {
    selectedAppBarTitle = S.of(context).KesmElA8zyaWlma4robat;
    drawerItemsAndScreensMap = {
      S.of(context).hogozat: ReservationViewBody(),
      S.of(context).eskan: HousingViewBody(),
      S.of(context).KesmElA8zyaWlma4robat: FoodAndBeverageView(),
      S.of(context).m8sla: WashingViewBody(),
      S.of(context).anshta: ActivitiesViewBody(),
    };
  }

  void changeSelectedScreen({
    required String drawerItemTitle,
    required BuildContext context,
  }) {
    selectedAppBarTitle = drawerItemTitle;
    selectedScreen = drawerItemsAndScreensMap[drawerItemTitle]!;
    emit(HomeChangeScreenState());
  }
}
