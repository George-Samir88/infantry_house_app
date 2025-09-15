import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infantry_house_app/views/widgets/food_and_beverage_view/food_and_beverage_view.dart';
import 'package:infantry_house_app/views/widgets/housing_view/housing_view.dart';
import 'package:infantry_house_app/views/widgets/reservation_view/reservation_view.dart';

import '../../../../generated/l10n.dart';
import '../../../widgets/activities_view/activities_view_body.dart';
import '../../washing_view/washing_view_body.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  late final GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  HomeCubit() : super(HomeInitial()) {
    scaffoldKey = GlobalKey<ScaffoldState>();
    getDepartmentsNames();
  }

  Map<String, String> departmentsMap = {};
  Map<String, Widget> drawerItemsAndScreensMap = {};
  String selectedAppBarTitle = '';
  Widget selectedScreen = FoodAndBeverageView(screenId: "3N9AIXGCa5qg4Db7AsBZ");
  String rootCollectionName = "screens_ar";

  void initializeDrawerItemsAndScreensMap({required BuildContext context}) {
    selectedAppBarTitle = S.of(context).KesmElA8zyaWlma4robat;
    drawerItemsAndScreensMap = {
      S.of(context).hogozat: ReservationView(
        screenId: departmentsMap["Reservation"]!,
      ),
      S.of(context).eskan: HousingView(screenId: departmentsMap["Housing"]!),
      S.of(context).KesmElA8zyaWlma4robat: FoodAndBeverageView(
        screenId: departmentsMap["FoodAndBeverage"]!,
      ),
      S.of(context).m8sla: WashingViewBody(
        screenId: departmentsMap["Washing"]!,
      ),
      S.of(context).anshta: ActivitiesViewBody(
        screenId: departmentsMap["Activities"]!,
      ),
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

  Future<List<String>> getDepartmentsNames() async {
    try {
      emit(HomeGetDepartmentsLoadingState());
      final querySnapshot = await firestore
          .collection(rootCollectionName)
          .get(GetOptions(source: Source.server));

      final screenNames =
          querySnapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>?; // Safe cast
                return data?['screen_name'] as String?;
              })
              .where(
                (name) => name != null && name.isNotEmpty,
              ) // Filter null/empty
              .cast<String>()
              .toList();
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        final name = data?['screen_name'] as String?;
        if (name != null && name.isNotEmpty) {
          departmentsMap[name] = doc.id;
        }
      }
      emit(HomeGetDepartmentsSuccessState());
      return screenNames;
    } on FirebaseException catch (e) {
      // Firestore-specific error
      emit(
        HomeGetDepartmentsFailureState(
          failure: "Firestore error: ${e.message}",
        ),
      );
      return [];
    } catch (e) {
      // Any other error
      emit(HomeGetDepartmentsFailureState(failure: e.toString()));
      return [];
    }
  }

  String? findDocIdByDepartmentName() {
    return departmentsMap.entries
            .firstWhere(
              (entry) => entry.value == "selectedDepartment",
              orElse: () => const MapEntry("", ""), // avoid crash if not found
            )
            .key
            .isEmpty
        ? null
        : departmentsMap.entries
            .firstWhere((entry) => entry.value == "selectedDepartment")
            .key;
  }
}
