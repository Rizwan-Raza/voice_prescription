import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:voice_prescription/blocs/auth.dart';
import 'package:voice_prescription/modals/user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthServices auth = Provider.of<AuthBase>(context, listen: false);
    UserModal user = auth.getUser();
    return Container(
      child: Center(
        child: Text(user.email),
      ),
    );
  }
}
