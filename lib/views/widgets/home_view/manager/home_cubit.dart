import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infantry_house_app/constants/screen_names.dart';
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
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  HomeCubit() : super(HomeInitial()) {
    scaffoldKey = GlobalKey<ScaffoldState>();
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
        screenId: departmentsMap[DepartmentsTitles.reservation]!,
      ),
      S.of(context).eskan: HousingView(
        screenId: departmentsMap[DepartmentsTitles.housing]!,
      ),
      S.of(context).KesmElA8zyaWlma4robat: FoodAndBeverageView(
        screenId: departmentsMap[DepartmentsTitles.foodAndBeverage]!,
      ),
      S.of(context).m8sla: WashingViewBody(
        screenId: departmentsMap[DepartmentsTitles.washing]!,
      ),
      S.of(context).anshta: ActivitiesViewBody(
        screenId: departmentsMap[DepartmentsTitles.activities]!,
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
      emit(HomeGetDepartmentsFailureState(failure: e.code));
      return [];
    } catch (e) {
      // Any other error
      emit(HomeGetDepartmentsFailureState(failure: e.toString()));
      return [];
    }
  }

  String? userRole;
  bool? isGeneralAdmin;
  bool? isGuest;

  Future<void> loadUserRole() async {
    final uid = firebaseAuth.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    userRole = userDoc.data()?['role'];
    isGeneralAdmin = userRole == "GeneralAdmin";
    isGuest = userRole == "Guest";
    emit(HomeUserRoleLoadedState(userRole: userRole!));
  }

  bool canManageScreen({required String screenName}) {
    return (isGeneralAdmin ?? false) ||
        (userRole == "adminOfReservation" &&
            screenName == DepartmentsTitles.reservation) ||
        (userRole == "adminOfHousing" &&
            screenName == DepartmentsTitles.housing) ||
        (userRole == "adminOfFoodAndBeverage" &&
            screenName == DepartmentsTitles.foodAndBeverage) ||
        (userRole == "adminOfWashing" &&
            screenName == DepartmentsTitles.washing) ||
        (userRole == "adminOfActivities" &&
            screenName == DepartmentsTitles.activities);
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
