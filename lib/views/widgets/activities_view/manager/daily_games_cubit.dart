import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infantry_house_app/models/daily_activity_item_model.dart';
import 'package:meta/meta.dart';

part 'daily_games_state.dart';

class DailyGamesCubit extends Cubit<DailyGamesState> {
  late List<DailyActivityItemModel> dailyActivities1;
  late List<DailyActivityItemModel> dailyActivities2;
  late List<String> dailyGamesCategories;
  late Map<String, List<DailyActivityItemModel>>
  mapBetweenCategoriesAndActivities = {};
  String selectedCategory = "ألعاب رياضية1";

  DailyGamesCubit() : super(DailyGamesInitial()) {
    dailyActivities1 = [
      DailyActivityItemModel(
        trainerName: "إبراهيم",
        activityImage: "assets/images/pilates.jfif",
        price: "18",
        title: "جلسة بيلاتس",
        description: "تمارين بيلاتس لتقوية العضلات وتحسين التوازن.",
      ),
      DailyActivityItemModel(
        trainerName: "يوسف",
        activityImage: "assets/images/boxing.jfif",
        price: "30",
        title: "تدريب الملاكمة",
        description: "تعلم تقنيات الملاكمة وزد من قوتك ولياقتك البدنية.",
      ),
      DailyActivityItemModel(
        trainerName: "حسين",
        activityImage: "assets/images/padel.jfif",
        price: "90",
        title: "البادل",
        description: "تعلم أساسيات لعبة البادل واستمتع بتجربة رياضية ممتعة.",
      ),
      DailyActivityItemModel(
        trainerName: "محمد",
        activityImage: "assets/images/cardio.png",
        price: "15",
        title: "تمارين الكارديو",
        description: "تمارين كارديو مكثفة لتعزيز اللياقة وصحة القلب.",
      ),
    ];
    dailyActivities2 = [
      DailyActivityItemModel(
        trainerName: "علي",
        activityImage: "assets/images/yoga.jfif",
        price: "20",
        title: "يوغا الصباح",
        description: "ابدأ يومك بجلسة يوغا منعشة تساعد على الاسترخاء.",
      ),
      DailyActivityItemModel(
        trainerName: "محمد",
        activityImage: "assets/images/cardio.png",
        price: "15",
        title: "تمارين الكارديو",
        description: "تمارين كارديو مكثفة لتعزيز اللياقة وصحة القلب.",
      ),
      DailyActivityItemModel(
        trainerName: "خالد",
        activityImage: "assets/images/swimming.jfif",
        price: "25",
        title: "تدريب السباحة",
        description: "حسن مهاراتك في السباحة مع مدرب محترف.",
      ),
    ];
    mapBetweenCategoriesAndActivities = {
      "ألعاب رياضية1": dailyActivities1,
      "ألعاب رياضية2": dailyActivities2,
      "ألعاب رياضية3": [],
    };
  }

  int currentSelectedItemIndex = 0;

  void changeSelectedItemIndex({required int index}) {
    currentSelectedItemIndex = index;
    emit(DailyGamesChangeCurrentSelectedIndexState());
  }

  int currentSelectedCategoryIndex = 0;

  void changeCategoryIndex({required int index}) {
    currentSelectedItemIndex = 0;
    currentSelectedCategoryIndex = index;
    selectedCategory =
        mapBetweenCategoriesAndActivities.keys
            .toList()[currentSelectedCategoryIndex];
    if (mapBetweenCategoriesAndActivities[selectedCategory]!.isNotEmpty) {
      triggerRotation();
    }
    emit(DailyGamesChangeCurrentCategoryIndexState());
  }

  double rotationAngle = 0.0;

  void initialRotation() {
    Future.delayed(Duration(milliseconds: 200), () {
      rotationAngle += 360; // Rotates once when opened
      emit(DailyGamesInitialAnimationState());
    });
  }

  void triggerRotation() {
    rotationAngle += 360;
    emit(DailyGamesTriggerAnimationState());
  }

  void resetCategorySelection() {
    if (mapBetweenCategoriesAndActivities.isNotEmpty) {
      selectedCategory = mapBetweenCategoriesAndActivities.keys.first;
      currentSelectedCategoryIndex = 0;
      currentSelectedItemIndex = 0;
    } else {
      mapBetweenCategoriesAndActivities.clear();
    }
    emit(DailyGamesResetCategorySelectionState());
  }

  ///-------- Category CRUD Operations --------
  void addNewCategory({required String newCategoryName}) {
    ///here i updated code because when deleting all items of map 'selectedCategory' variable still assigned to the last value as it was before deleting all items of map
    if (mapBetweenCategoriesAndActivities.isNotEmpty) {
      mapBetweenCategoriesAndActivities[newCategoryName] = [];
    } else if (mapBetweenCategoriesAndActivities.isEmpty) {
      mapBetweenCategoriesAndActivities[newCategoryName] = [];
      selectedCategory = mapBetweenCategoriesAndActivities.keys.first;
    }
    emit(DailyGamesAddNewCategoryState());
  }

  void removeExistingCategory({required String categoryTitle}) {
    mapBetweenCategoriesAndActivities.remove(categoryTitle);
    resetCategorySelection();
    emit(DailyGamesRemoveCategoryState());
  }

  ///-------- Activity CRUD Operations --------
  void addNewItem({required DailyActivityItemModel newActivity}) {
    mapBetweenCategoriesAndActivities[selectedCategory]!.add(newActivity);
    emit(DailyGamesAddNewItemState());
  }

  void removeExistingItem({required DailyActivityItemModel activity}) {
    if (mapBetweenCategoriesAndActivities[selectedCategory]!.isNotEmpty) {
      mapBetweenCategoriesAndActivities[selectedCategory]!.remove(activity);
      currentSelectedItemIndex = 0;
    }
    emit(DailyGamesRemoveItemState());
  }

  void updateDailyActivityItem({
    required String title,
    required String description,
    required String trainerName,
    required String activityImage,
    required String price,
  }) {
    // Get the current item
    var currentItem =
        mapBetweenCategoriesAndActivities[selectedCategory]![currentSelectedItemIndex];

    // Only update the field if it's different
    var updatedItem = currentItem.copyWith(
      title: title != currentItem.title ? title : null,
      description: description != currentItem.description ? description : null,
      trainerName: trainerName != currentItem.trainerName ? trainerName : null,
      activityImage:
          activityImage != currentItem.activityImage ? activityImage : null,
      price: price != currentItem.price ? price : null,
    );

    // Replace the item in the list
    mapBetweenCategoriesAndActivities[selectedCategory]![currentSelectedItemIndex] =
        updatedItem;
    emit(DailyGamesUpdateItemState());
  }
}
