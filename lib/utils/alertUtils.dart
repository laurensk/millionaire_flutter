import 'package:flutter/material.dart';

class AlertUtils {

  static void showAlert(BuildContext context, String title, String text, String imageAsset, String closeButtonText, Color backgroundColor, Color buttonColor) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                              overflow: Overflow.visible,
                              alignment: AlignmentDirectional.topCenter,
                              children: <Widget>[
                                Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 74,
                                        ),
                                        new Text(
                                          title,
                                          style: TextStyle(
                                            fontFamily: "Brandon Text",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 32,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 9,
                                        ),
                                        new Text(
                                          text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "Helvetica Neue",
                                            fontSize: 15,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                closeButtonText,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "Helvetica Neue",
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 22,
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            height: 42.00,
                                            width: 290.00,
                                            decoration: BoxDecoration(
                                              color: buttonColor,
                                              border: Border.all(
                                                width: 1.00,
                                                color: Color(0xffffffff),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.00),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    height: 230.00,
                                    width: 356.00,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2.00,
                                        color: Color(0xffffffff),
                                      ),
                                      color: backgroundColor,
                                      borderRadius:
                                          BorderRadius.circular(15.00),
                                    )),
                                Positioned(
                                  top: -75,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 40),
                                    child: Image.asset(
                                      imageAsset,
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ),
                              ]),
                        ]),
                  )));
        });
  }


}