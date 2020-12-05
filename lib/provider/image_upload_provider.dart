import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:society_network/enums/view_state.dart';


class ImageUploadProvider with ChangeNotifier{

ViewState _viewState=ViewState.IDLE;

ViewState get getViewState => _viewState;

  void setToLoading() {
    _viewState = ViewState.LOADING;
    notifyListeners();
  }

  void setToIdle() {
    _viewState = ViewState.IDLE;
    notifyListeners();
  }

}