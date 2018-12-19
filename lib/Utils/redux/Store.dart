import 'package:flutter/material.dart';
//import 'package:flutter_redux/flutter_redux.dart';
import 'Reducer.dart';

/// 管理登录状态'
class AuthState{
  bool isLogin;     //是否登录
  String account;   //用户名
  AuthState({this.isLogin:false,this.account});

  @override
  String toString() {
    return "{account:$account,isLogin:$isLogin}";
  }
}
/// 管理主页状态
class MainPageState {
  int counter;

  MainPageState({this.counter: 0});

  @override
  String toString() {
    return "{counter:$counter}";
  }
}

/// 应用程序状态
class AppState {
  AuthState auth; //登录
  MainPageState main; //主页

  AppState({this.main, this.auth});

  @override
  String toString() {
    return "{auth:$auth,main:$main}";
  }
}
