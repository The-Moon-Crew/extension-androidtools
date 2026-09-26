package;

import extension.Android;
import extension.androidtools.content.Context;
import extension.androidtools.os.Build;
import extension.androidtools.os.Build.VERSION;
import extension.androidtools.os.Environment;

class Main extends lime.app.Application
{
	public function new():Void
	{
		super();
	}

	public override function onWindowCreate():Void
	{
		super.onWindowCreate();

		Android.init();
		Android.showAlertDialog('Extension-AndroidTools', buildReport(), 'OK');
	}

	private function buildReport():String
	{
		final lines:Array<String> = [
			'Device: ${Build.MANUFACTURER} ${Build.MODEL}',
			'Brand: ${Build.BRAND}',
			'Hardware: ${Build.HARDWARE}',
			'Emulator: ${Build.isEmulator()}',
			'Android: ${VERSION.RELEASE} (SDK ${VERSION.SDK_INT})',
			'Security patch: ${VERSION.SECURITY_PATCH}',
			'Package: ${Android.getPackageName()}',
			'App version: ${Android.getVersionName()} (${Android.getVersionCode()})',
			'Screen: ${Android.getScreenWidth()}x${Android.getScreenHeight()} @ ${Android.getScreenDpi()}dpi, ${Android.getRefreshRate()}Hz',
			'Dark mode: ${Android.isDarkMode()}',
			'Locale: ${Android.getLocale()}',
			'Battery: ${Android.getBatteryLevel()}% (charging: ${Android.isCharging()}, ${Android.getBatteryTemperature()} C)',
			'Network: ${Android.getNetworkType()}',
			'Memory: ${Math.round(Android.getAvailableMemory() / 1048576)} / ${Math.round(Android.getTotalMemory() / 1048576)} MB',
			'Storage free: ${Math.round(Android.getFreeStorage() / 1048576)} MB',
			'Rooted: ${Android.isRooted()}',
			'Files dir: ${Context.getFilesDir()}',
			'External files dir: ${Context.getExternalFilesDir()}',
			'Cache dir: ${Context.getCacheDir()}',
			'External storage: ${Environment.getExternalStorageDirectory()} (${Environment.getExternalStorageState()})'
		];

		return lines.join('\n');
	}

	public override function render(context:lime.graphics.RenderContext):Void
	{
		switch (context.type)
		{
			case CAIRO:
				context.cairo.setSourceRGB(0.75, 1, 0);
				context.cairo.paint();
			case CANVAS:
				context.canvas2D.fillStyle = '#BFFF00';
				context.canvas2D.fillRect(0, 0, window.width, window.height);
			case DOM:
				context.dom.style.backgroundColor = '#BFFF00';
			case FLASH:
				context.flash.graphics.beginFill(0xBFFF00);
				context.flash.graphics.drawRect(0, 0, window.width, window.height);
			case OPENGL | OPENGLES | WEBGL:
				context.webgl.clearColor(0.75, 1, 0, 1);
				context.webgl.clear(context.webgl.COLOR_BUFFER_BIT);
			default:
		}
	}
}
