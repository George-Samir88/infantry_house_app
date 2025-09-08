part of 'daily_games_cubit.dart';

@immutable
sealed class DailyGamesState {}

final class DailyGamesInitial extends DailyGamesState {}

final class DailyGamesChangeCurrentSelectedIndexState extends DailyGamesState {}

final class DailyGamesChangeCurrentCategoryIndexState extends DailyGamesState {}

final class DailyGamesTriggerAnimationState extends DailyGamesState {}

final class DailyGamesInitialAnimationState extends DailyGamesState {}

///-----------------------------Categories Crud------------------------------
final class DailyGamesAddNewCategoryState extends DailyGamesState {}

final class DailyGamesRemoveCategoryState extends DailyGamesState {}

final class DailyGamesResetCategorySelectionState extends DailyGamesState {}

///-----------------------------Items Crud------------------------------
final class DailyGamesAddNewItemState extends DailyGamesState {}

final class DailyGamesRemoveItemState extends DailyGamesState {}

final class DailyGamesUpdateItemState extends DailyGamesState {}

