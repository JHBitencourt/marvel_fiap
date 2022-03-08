import 'package:flutter/widgets.dart';

const initialRoute = 'initial';
const signUpRoute = 'signUp';
const characterDetailsRoute = 'characterDetails';

void scheduleRedirectToRoute(BuildContext context, String route,
    {List<dynamic>? arguments, String? removeUntilRoute}) {
  if (removeUntilRoute != null) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        route,
        ModalRoute.withName(removeUntilRoute),
        arguments: arguments,
      );
    });
  } else {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.of(context).pushNamed(route, arguments: arguments);
    });
  }
}

/// If [stopAtInitialRoute] is equal true, the routes will be popped until
/// the [popUntilRoute] or the [initialRoute].
void schedulePopAll(
  BuildContext context, {
  String popUntilRoute = initialRoute,
  bool stopAtInitialRoute = false,
}) {
  WidgetsBinding.instance?.addPostFrameCallback((_) {
    Navigator.of(context).popUntil((Route<dynamic> route) {
      if (stopAtInitialRoute) {
        return ModalRoute.withName(popUntilRoute).call(route) ||
            ModalRoute.withName(initialRoute).call(route);
      }

      return ModalRoute.withName(popUntilRoute).call(route);
    });
  });
}

void scheduleExecution(VoidCallback execution) {
  WidgetsBinding.instance?.addPostFrameCallback((_) {
    execution();
  });
}
