// Copyright (c) 2022 foxsofter.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_thrio/flutter_thrio.dart';

import '../../../route.dart';
import '../../../types/people.dart';
import '../notifies/flutter1_notify.dart';

part 'home.state.dart';
part 'home.context.dart';

class HomePage extends NavigatorStatefulPage {
  const HomePage({
    super.key,
    required super.moduleContext,
    required super.settings,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with NavigatorPageLifecycleMixin, AutomaticKeepAliveClientMixin {
  late final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    ThrioLogger.d('page1 dispose: ${widget.settings.index}');
    _inputController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didAppear(final RouteSettings routeSettings) {
    ThrioLogger.d('flutter1 didAppear: $routeSettings ');
    // \n ${StackTrace.current}
  }

  @override
  void didDisappear(final RouteSettings routeSettings) {
    ThrioLogger.d('flutter1 didDisappear: $routeSettings ');
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return NavigatorRoutePush(
      urls: [biz.biz2.flutter2.url],
      onPush: (final settings, {final animated = true}) async {
        // root.biz1.flutter1.home.replace(newUrl: root.biz2.flutter2.url);
        ThrioLogger.d('page2 onPush');
        return NavigatorRoutePushHandleType.none;
      },
      child: NavigatorPageNotify(
          name: 'all_page_notify',
          onPageNotify: (final params) =>
              ThrioLogger.v('flutter1 receive all page notify:$params'),
          child: Flutter1Notify(
              onNotify: ({final intValue = 0}) =>
                  ThrioLogger.v('flutter1 receive notify:$intValue'),
              child: Scaffold(
                  appBar: PreferredSize(
                      preferredSize: Platform.isIOS
                          ? const Size.fromHeight(44)
                          : const Size.fromHeight(56),
                      child: AppBar(
                        backgroundColor: Colors.blue,
                        title: const Text('thrio_example',
                            style: TextStyle(color: Colors.black)),
                        leading: context.showPopAwareWidget(const IconButton(
                          color: Colors.black,
                          tooltip: 'back',
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: ThrioNavigator.pop,
                        )),
                        systemOverlayStyle: SystemUiOverlayStyle.dark,
                      )),
                  body: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      child: Column(children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            'flutter1: index is ${widget.settings.index}',
                            style: const TextStyle(
                                fontSize: 28, color: Colors.blue),
                          ),
                        ),
                        SizedBox(
                            height: 25,
                            width: 100,
                            child: TextField(
                                controller: _inputController,
                                textInputAction: TextInputAction.search,
                                // onSubmitted: onSubmitted,
                                decoration: const InputDecoration(
                                  hintText: 'hintText',
                                  contentPadding: EdgeInsets.only(bottom: 12),
                                  border: InputBorder.none,
                                ),
                                onChanged: print)),
                        InkWell(
                          onTap: () {
                            final mtx = NavigatorPage.moduleContextOf(context);
                            ThrioLogger.v('$mtx');
                            final murl = NavigatorPage.urlOf(context);
                            ThrioLogger.v(murl);
                            final rmtx = NavigatorPage.moduleContextOf(context,
                                pageModuleContext: true);
                            ThrioLogger.v('$rmtx');
                            final rmurl = NavigatorPage.urlOf(context,
                                pageModuleContext: true);
                            ThrioLogger.v(rmurl);
                            if (widget.moduleContext
                                .setStringKeyBiz1(_inputController.text)) {
                              final value = widget.moduleContext.stringKeyBiz1;
                              ThrioLogger.v('stringKeyBiz1 value is $value');
                            }
                            if (widget.moduleContext
                                .setIntKeyRootModule(10000)) {
                              final value =
                                  widget.moduleContext.intKeyRootModule;
                              ThrioLogger.v('intKeyRootModule value is $value');
                            }

                            final value =
                                widget.moduleContext.get('people_from_native');
                            ThrioLogger.v('people_from_native value is $value');
                          },
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              color: Colors.yellow,
                              child: const Text(
                                'set module context',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              )),
                        ),
                        InkWell(
                          onTap: () async {
                            final params = await biz.biz1.flutter1.home.push(
                                strList: <String>['foxsofter', 'sex', '男性'],
                                goodMap: <String, dynamic>{'good': 'man'});
                            ThrioLogger.v('/biz1/flutter1 strList:$strList');
                            ThrioLogger.v('/biz1/flutter1 goodMap:$goodMap');

                            ThrioLogger.v('/biz1/flutter1 popped:$params');
                          },
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              color: Colors.yellow,
                              child: const Text(
                                'push flutter1',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              )),
                        ),
                        InkWell(
                          onTap: biz.biz1.flutter1.home.remove,
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              color: Colors.yellow,
                              child: const Text(
                                'remove flutter1',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              )),
                        ),
                        InkWell(
                          onTap: () async {
                            final params = await biz.biz2.flutter2.push(
                              params: People(name: '大宝剑', age: 0, sex: 'x'),
                            );
                            ThrioLogger.v(
                                '${biz.biz2.flutter2.url} poppedResult call popped:$params');
                          },
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              color: Colors.yellow,
                              child: const Text(
                                'push flutter2',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              )),
                        ),
                        InkWell(
                          onTap: () => ThrioNavigator.pop(
                              params: People(name: '大宝剑', age: 0, sex: 'x')),
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              color: Colors.yellow,
                              child: const Text(
                                'pop',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              )),
                        ),
                        InkWell(
                          onTap: () async {
                            final params = await ThrioNavigator.push(
                              url: '/biz1/native1',
                              params: People(name: '大宝剑', age: 10, sex: 'x'),
                            );
                            ThrioLogger.v(
                                '/biz1/native1 poppedResult call params:$params');
                          },
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              color: Colors.grey,
                              child: const Text(
                                'push native1',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              )),
                        ),
                        InkWell(
                          onTap: () => ThrioNavigator.notify(
                            url: '/biz1/native1',
                            name: 'aaa',
                            params: {
                              '1': {'2': '3'}
                            },
                          ),
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              color: Colors.grey,
                              child: const Text(
                                'notify native1',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              )),
                        ),
                        InkWell(
                          onTap: () =>
                              ThrioNavigator.remove(url: '/biz1/native1'),
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              color: Colors.grey,
                              child: const Text(
                                'remove native1',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              )),
                        ),
                        InkWell(
                          onTap: () => ThrioNavigator.replace(
                            url: biz.biz1.flutter1.home.url,
                            newUrl: biz.biz2.flutter2.url,
                          ),
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              color: Colors.grey,
                              child: const Text(
                                'replace flutter2',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              )),
                        ),
                        InkWell(
                          onTap: () async {
                            final canPop = await ThrioNavigator.canPop();
                            debugPrint('canPop: $canPop');
                          },
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              color: Colors.grey,
                              child: const Text(
                                'canPop',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              )),
                        ),
                        NavigatorPageLifecycle(
                            didAppear: (final settings) {
                              ThrioLogger.v('home  didAppear -> $settings');
                            },
                            didDisappear: (final settings) {
                              ThrioLogger.v('home  didDisappear -> $settings');
                            },
                            child: StreamBuilder<Object>(
                                stream:
                                    widget.moduleContext.on('stringKeyBiz1'),
                                builder: (final context, final snapshot) =>
                                    Container(
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.all(8),
                                        color: Colors.grey,
                                        child: Text(
                                          '${snapshot.data}',
                                          style: const TextStyle(
                                              fontSize: 22,
                                              color: Colors.black),
                                        ))))
                      ]),
                    ),
                  )))),
    );
  }
}
