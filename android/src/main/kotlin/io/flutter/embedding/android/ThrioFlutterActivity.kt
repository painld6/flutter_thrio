/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2019 foxsofter
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

package io.flutter.embedding.android

import android.content.Context
import android.content.pm.PackageManager
import com.foxsofter.flutter_thrio.BooleanCallback
import com.foxsofter.flutter_thrio.IntCallback
import com.foxsofter.flutter_thrio.navigator.NavigationController
import com.foxsofter.flutter_thrio.navigator.ThrioNavigator
import io.flutter.embedding.engine.FlutterEngine

open class ThrioFlutterActivity : FlutterActivity(), ThrioFlutterActivityBase {
    companion object {
        var isInitialUrlPushed = false
    }

    private val activityDelegate by lazy { ThrioFlutterActivityDelegate(this) }

    override val engine: com.foxsofter.flutter_thrio.navigator.FlutterEngine?
        get() = activityDelegate.engine

    override fun provideFlutterEngine(context: Context): FlutterEngine? =
        activityDelegate.provideFlutterEngine(context)

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) =
        activityDelegate.cleanUpFlutterEngine(flutterEngine)

    override fun onFlutterUiDisplayed() {
        if (!isInitialUrlPushed && initialUrl?.isNotEmpty() == true) {
            isInitialUrlPushed = true
            NavigationController.Push.push(initialUrl!!, null, false) {}
        }
        super.onFlutterUiDisplayed()
    }

    override fun shouldDestroyEngineWithHost(): Boolean =
        activityDelegate.shouldDestroyEngineWithHost()

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() = ThrioNavigator.maybePop()

    override fun onPush(arguments: Map<String, Any?>?, result: BooleanCallback) =
        activityDelegate.onPush(arguments, result)

    override fun onNotify(arguments: Map<String, Any?>?, result: BooleanCallback) =
        activityDelegate.onNotify(arguments, result)

    override fun onMaybePop(arguments: Map<String, Any?>?, result: IntCallback) =
        activityDelegate.onMaybePop(arguments, result)

    override fun onPop(arguments: Map<String, Any?>?, result: BooleanCallback) =
        activityDelegate.onPop(arguments, result)

    override fun onPopTo(arguments: Map<String, Any?>?, result: BooleanCallback) =
        activityDelegate.onPopTo(arguments, result)

    override fun onRemove(arguments: Map<String, Any?>?, result: BooleanCallback) =
        activityDelegate.onRemove(arguments, result)

    override fun onReplace(arguments: Map<String, Any?>?, result: BooleanCallback) =
        activityDelegate.onReplace(arguments, result)

    override fun onCanPop(arguments: Map<String, Any?>?, result: BooleanCallback) =
        activityDelegate.onCanPop(arguments, result)

    private fun readInitialUrl() {
        val activityInfo =
            packageManager.getActivityInfo(componentName, PackageManager.GET_META_DATA)
        _initialUrl = if (activityInfo.metaData == null) "" else {
            activityInfo.metaData.getString("io.flutter.InitialUrl", "")
        }
    }

    private var _initialUrl: String? = null

    protected open val initialUrl: String?
        get() {
            if (_initialUrl == null) {
                readInitialUrl()
            }
            return _initialUrl!!
        }
}