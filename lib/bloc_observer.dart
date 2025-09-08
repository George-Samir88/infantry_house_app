import 'package:flutter_bloc/flutter_bloc.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print(change.toString());
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print("closed ${bloc.toString()}");
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print("created ${bloc.toString()}");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    // TODO: implement onError
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);

    // TODO: implement onEvent
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition.toString());
  }
}