// The MIT License (MIT)
//
// Copyright (c) 2019 Hellobike Group
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

// ignore_for_file: avoid_as

import 'package:flutter/widgets.dart';

final _parentOf = Expando<RouteSettings>();

final _isSelectedOf = Expando<bool>();

extension NavigatorRouteSettings on RouteSettings {
  static int _fakeIndex = 0x7fffffff;

  static RouteSettings get nullSettings => const RouteSettings(name: '');

  /// Construct RouteSettings with url, index, params.
  ///
  static RouteSettings settingsWith({
    required final String url,
    final int? index = 0,
    final dynamic params,
  }) {
    final idx = index ?? _fakeIndex--;
    return RouteSettings(
      name: '$idx $url',
      arguments: <String, dynamic>{'params': params},
    );
  }

  /// Converting arguments to route settings.
  ///
  static RouteSettings? fromArguments(final Map<String, dynamic>? arguments) {
    if ((arguments != null && arguments.isNotEmpty) &&
        arguments.containsKey('url') &&
        arguments.containsKey('index')) {
      final urlValue = arguments['url'];
      final url = urlValue is String ? urlValue : null;
      final indexValue = arguments['index'];
      final index = indexValue is int ? indexValue : null;
      final isNested = arguments['isNested'] == true;
      final params = arguments['params'];
      return RouteSettings(
        name: '$index $url',
        arguments: <String, dynamic>{'isNested': isNested, 'params': params},
      );
    }
    return null;
  }

  static RouteSettings? fromNewUrlArguments(
      final Map<String, dynamic>? arguments) {
    if ((arguments != null && arguments.isNotEmpty) &&
        arguments.containsKey('newUrl') &&
        arguments.containsKey('newIndex')) {
      final urlValue = arguments['newUrl'];
      final url = urlValue is String ? urlValue : null;
      final indexValue = arguments['newIndex'];
      final index = indexValue is int ? indexValue : null;
      final isNested = arguments['isNested'] == true;
      return RouteSettings(
          name: '$index $url',
          arguments: <String, dynamic>{'isNested': isNested});
    }
    return null;
  }

  Map<String, dynamic> toArguments() => <String, dynamic>{
        'url': url,
        'index': index,
        'params': params,
      };

  RouteSettings? get parent => _parentOf[this];

  set parent(final RouteSettings? parent) {
    _parentOf[this] = parent;
  }

  bool? get isSelected {
    if (parent == null) {
      return null;
    }
    return _isSelectedOf[this];
  }

  set isSelected(final bool? selected) {
    _isSelectedOf[this] = selected;
  }

  String get url {
    final settingsName = name;
    return settingsName == null ||
            settingsName.isEmpty ||
            !settingsName.contains(' ')
        ? ''
        : settingsName.split(' ').last;
  }

  int get index {
    final settingsName = name;
    return settingsName == null ||
            settingsName.isEmpty ||
            !settingsName.contains(' ')
        ? 0
        : int.tryParse(settingsName.split(' ').first) ?? 0;
  }

  bool get isNested {
    if (arguments != null && arguments is Map) {
      return (arguments as Map<String, dynamic>)['isNested'] == true;
    }
    return false;
  }

  dynamic get params {
    if (arguments != null && arguments is Map) {
      return (arguments as Map<String, dynamic>)['params'];
    }
    return null;
  }

  set params(final dynamic value) {
    if (arguments != null && arguments is Map) {
      (arguments as Map<String, dynamic>)['params'] = value;
    }
  }
}
