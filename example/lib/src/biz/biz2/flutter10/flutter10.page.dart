// Copyright (c) 2023 foxsofter.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_thrio/flutter_thrio.dart';

part 'flutter10.context.dart';
part 'flutter10.state.dart';

class Flutter10Page extends NavigatorStatefulPage {
  const Flutter10Page({
    super.key,
    required super.moduleContext,
    required super.settings,
  });

  @override
  _Flutter10PageState createState() => _Flutter10PageState();
}

class _Flutter10PageState extends State<Flutter10Page>
    with NavigatorPageLifecycleMixin, AutomaticKeepAliveClientMixin {
  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('thrio_build_example',
            style: TextStyle(color: Colors.black)),
        leading: context.showPopAwareWidget(const IconButton(
          color: Colors.black,
          tooltip: 'back',
          icon: Icon(Icons.arrow_back_ios),
          onPressed: ThrioNavigator.pop,
        )),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: const SizedBox(
        height: 100,
        child: Text('flutter 10'),
      ),
    );
  }

  @override
  void didAppear(final RouteSettings settings) {
    ThrioLogger.d('flutter10 didAppear: $settings ');
  }

  @override
  void didDisappear(final RouteSettings settings) {
    ThrioLogger.d('flutter10 didDisappear: $settings ');
  }

  @override
  bool get wantKeepAlive => true;
}
