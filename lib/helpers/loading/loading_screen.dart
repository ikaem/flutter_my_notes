import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/helpers/loading/loading_screen_controller.dart';

class LoadingScreen {
  // singleton
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();
  // make sure that any call to LoadingScreen construtor returns same shared instance
  factory LoadingScreen() => _shared;

  LoadingScreenController? controller;

  void hide() {
    controller?.close();
    controller = null;
  }

  void show({
    required BuildContext context,
    required String text,
  }) {
    // NOTE i dont like this one
    // if (controller?.update(text) ?? false) {
    //   return;
    // } else {
    //   controller = showOverlay(context: context, text: text);
    // }
    if (controller != null) return;
    if (controller?.update != null) return;

    controller = showOverlay(context: context, text: text);
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    // this is controller for the stream
    final _textStreamController = StreamController<String>();
    _textStreamController.add(text);

    final overlayState = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlayEntry = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(150),
        child: Center(
            child: Container(
          constraints: BoxConstraints(
            maxWidth: size.width * 0.8,
            minWidth: size.width * 0.5,
            maxHeight: size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  const CircularProgressIndicator(),
                  SizedBox(
                    height: 20.0,
                  ),
                  StreamBuilder<String>(builder: ((context, snapshot) {
                    final content = snapshot.data;
                    if (!snapshot.hasData) return Container();
                    if (content == null) return Container();
                    return Text(
                      content,
                      textAlign: TextAlign.center,
                    );
                  }))
                ],
              ),
            ),
          ),
        )),
      );
    });

    overlayState?.insert(overlayEntry);

    return LoadingScreenController(close: () {
      _textStreamController.close();
      overlayEntry.remove();
      return true;
    }, update: (String text) {
      _textStreamController.add(text);
      return true;
    });
  }
}
