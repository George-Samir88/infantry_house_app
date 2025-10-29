part of 'academies_cubit.dart';

@immutable
sealed class AcademiesState {}

final class DailyGamesInitial extends AcademiesState {}

final class DailyGamesChangeCurrentSelectedIndexState extends AcademiesState {}

final class DailyGamesChangeCurrentCategoryIndexState extends AcademiesState {}

final class DailyGamesTriggerAnimationState extends AcademiesState {}

final class DailyGamesInitialAnimationState extends AcademiesState {}

///-----------------------------Categories Crud------------------------------
final class DailyGamesAddNewCategoryState extends AcademiesState {}

final class DailyGamesRemoveCategoryState extends AcademiesState {}

final class DailyGamesResetCategorySelectionState extends AcademiesState {}

///-----------------------------Items Crud------------------------------
final class DailyGamesAddNewItemState extends AcademiesState {}

final class DailyGamesRemoveItemState extends AcademiesState {}

final class DailyGamesUpdateItemState extends AcademiesState {}

