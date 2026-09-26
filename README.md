## extension-androidtools

![](https://img.shields.io/github/repo-size/LimeExtensions/extension-androidtools) ![](https://badgen.net/github/open-issues/LimeExtensions/extension-androidtools) ![](https://badgen.net/badge/license/MIT/green)

A Haxe/[Lime](https://lime.openfl.org) extension that incorporates Java functions through [JNI](https://en.m.wikipedia.org/wiki/Java_Native_Interface).

### Installation

You can install it through `Haxelib`
```bash
haxelib install extension-androidtools
```
Or through `Git`, if you want the latest updates
```bash
haxelib git extension-androidtools https://github.com/The-Moon-Crew/extension-androidtools.git
```

### Usage

Add the library to your `project.xml`
```xml
<haxelib name="extension-androidtools" />
```

Call `Android.init()` once at startup if you use permission or activity result callbacks, then use the facade or the individual classes.

```haxe
import extension.Android;

Android.init();

Android.makeToastText('Hello');
Android.vibrate(200);

if (Android.isNetworkAvailable() && Android.isPackageInstalled('com.android.chrome'))
	Android.openUrl('https://lime.openfl.org');

Android.requestPermissionsWithFallback(['CAMERA'], 1, function():Void {
	Android.makeToastText('Camera granted');
}, function(denied:Array<String>):Void {
	Android.makeToastText('Denied: ' + denied.join(', '));
});
```

### Advanced usage

Lifecycle, memory and intent events (initialized by `Android.init()`):

```haxe
CallBack.onPause.add(function():Void {});
CallBack.onResume.add(function():Void {});
CallBack.onTrimMemory.add(function(data:TrimMemoryData):Void {});
CallBack.onNewIntent.add(function(data:NewIntentData):Void {});
```

Sensors are unregistered on pause and registered again on resume automatically:

```haxe
SensorManager.start(SensorManager.TYPE_ACCELEROMETER, SensorManager.DELAY_GAME, function(data:SensorEventData):Void {
	var x:Float = data.values[0];
});
```

Network and battery monitors:

```haxe
Network.onChanged.add(function(data:NetworkChangedData):Void {});
Network.startMonitor();

Battery.onChanged.add(function(data:BatteryChangedData):Void {});
Battery.startMonitor();
```

Persistent key-value storage:

```haxe
var prefs:Preferences = new Preferences('game');
prefs.setInt('score', 10);
var score:Int = prefs.getInt('score');
```

System file picker with no storage permission required:

```haxe
Documents.pickFile(function(uris:Array<String>):Void {
	if (uris.length > 0)
		Documents.copyToFile(uris[0], Context.getCacheDir() + '/picked');
}, 'image/*');
```

Haptics and advanced notifications:

```haxe
Vibrator.vibratePattern([0, 50, 100, 50]);
Vibrator.vibrateEffect(Vibrator.EFFECT_HEAVY_CLICK);
Vibrator.haptic(Vibrator.HAPTIC_CONFIRM);

Notifications.showProgress(7, 'Downloading', 'Please wait', 40);
Notifications.showAdvanced({title: 'Update', message: 'Ready', bigText: 'A long description', importance: Notifications.IMPORTANCE_HIGH});
```

Screen safe area for notches and system bars:

```haxe
var insets:SafeInsets = Display.getSafeInsets();
```

### Classes

| Class | Purpose |
| --- | --- |
| `extension.Android` | Facade with the most common functions |
| `extension.Content` | Application directories and storage state |
| `androidtools.Permissions` | Runtime permissions, sync and async |
| `androidtools.Settings` | Open system settings screens |
| `androidtools.callback.CallBack` / `HelperBack` | Activity result and permission result events |
| `androidtools.app.Notifications` | Basic and advanced notifications, progress, cancel |
| `androidtools.content.Context` | Files, cache and OBB directories |
| `androidtools.content.Clipboard` | Read and write clipboard text |
| `androidtools.content.Intents` | Open URLs, share text, launch packages |
| `androidtools.content.PackageManager` | Installed packages and version info |
| `androidtools.content.Preferences` | Persistent key-value storage |
| `androidtools.content.Documents` | System file picker and URI file access |
| `androidtools.hardware.SensorManager` | Accelerometer, gyroscope and other sensors |
| `androidtools.media.AudioManager` | Volume, ringer mode, audio focus |
| `androidtools.media.MediaImage` | Save to gallery, image size and orientation |
| `androidtools.net.Network` | Connectivity type, availability and change monitor |
| `androidtools.os.Build` | `android.os.Build` fields |
| `androidtools.os.Environment` | `android.os.Environment` paths and state |
| `androidtools.os.Battery` | Level, charging, temperature, power save and change monitor |
| `androidtools.os.Vibrator` | Vibrate, patterns, effects and haptic feedback |
| `androidtools.os.DeviceInfo` | Memory, storage, CPU count, root, locale |
| `androidtools.view.Display` | Size, density, refresh rate, orientation, brightness, immersive mode, safe insets |
| `androidtools.play.PlayTime` | Uptime and session timer |
| `androidtools.widget.Toast` | Toast messages |

### Manifest permissions

The library manifest declares `VIBRATE`, `ACCESS_NETWORK_STATE` and `MODIFY_AUDIO_SETTINGS`. Anything else your app uses, such as `CAMERA`, `RECORD_AUDIO`, `ACTIVITY_RECOGNITION` (step counter) or storage access, must be declared in your own project.

On Android 11 and newer, `isPackageInstalled` and `launchPackage` only see packages that your manifest makes visible through `<queries>` or `QUERY_ALL_PACKAGES`.

## Licensing

**extension-androidtools** is made available under the **MIT License**. Check [LICENSE](./LICENSE) for more information.
