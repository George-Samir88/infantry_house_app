import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../widgets/activities_view/activities_view_body.dart';
import '../../../widgets/housing_view/housing_view_body.dart';
import '../../../widgets/reservation_view/reservation_view_body.dart';
import '../../../widgets/washing_view/washing_view_body.dart';
import '../../food_and_beverage_view/food_and_beverage_view_body.dart';


part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  Map<String, Widget> drawerItemsAndScreensMap = {};
  String selectedAppBarTitle = '';
  Widget selectedScreen = FoodAndBeverageViewBody();

  void initializeDrawerItemsAndScreensMap({required BuildContext context}) {
    selectedAppBarTitle = S.of(context).KesmElA8zyaWlma4robat;
    drawerItemsAndScreensMap = {
      S.of(context).hogozat: ReservationViewBody(),
      S.of(context).eskan: HousingViewBody(),
      S.of(context).KesmElA8zyaWlma4robat: FoodAndBeverageViewBody(),
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
