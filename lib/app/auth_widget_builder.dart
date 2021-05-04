import 'package:amrita_quizzes/services/auth_service.dart';
import 'package:amrita_quizzes/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Used to create user-dependent objects that need to be accessible by all widgets.
/// This widgets should live above the [MaterialApp].
/// See [AuthWidget], a descendant widget that consumes the snapshot generated by this builder.
class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key key, @required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<MyAppUser>) builder;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return StreamBuilder<MyAppUser>(
      stream: authService.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<MyAppUser> snapshot) {
        final MyAppUser user = snapshot.data;
        if (user != null) {
          final DatabaseService dbs = DatabaseService(uid: user.uid);
          return MultiProvider(
            providers: [
              Provider<MyAppUser>.value(value: user),
              // NOTE: Any other user-bound providers here can be added here
              Provider<Database>.value(value: dbs)
            ],
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}
