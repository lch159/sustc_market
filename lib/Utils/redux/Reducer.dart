
import 'package:sustc_market/Utils/redux/Action.dart';
import 'package:sustc_market/Utils/redux/Store.dart';

AuthState mainReducer(AuthState state, dynamic action) {


  if (Actions.LogoutSuccess == action) {
    state.isLogin = false;
    state.account = null;
  }

  if (action is LoginSuccessAction) {
    state.isLogin = true;
    state.account = action.account;
    return state;
  }



  return state;
}
