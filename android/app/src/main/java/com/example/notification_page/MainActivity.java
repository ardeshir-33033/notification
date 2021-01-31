package com.example.notification_page;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private Intent service;
    private static final String CHANNEL = "samples.flutter.dev/battery";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        private int getBatteryLevel () {
            int batteryLevel = -1;
            if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
                BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
                batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
            } else {
                Intent intent = new ContextWrapper(getApplicationContext()).
                        registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
                batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                        intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
            }

            return batteryLevel;
        }

        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            // TODO
                            if (call.method.equals("getBatteryLevel")) {
                                int batteryLevel = getBatteryLevel();

                                if (batteryLevel != -1) {
                                    result.success(batteryLevel);
                                } else {
                                    result.error("UNAVAILABLE", "Battery level not available.", null);
                                }
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(new FlutterEngine(this));

        service = new Intent(MainActivity.this, MyService.class);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(service);
        } else {
            startService(service);
        }
    }
//    public void onReceive(Context context, Intent intent) {
//        if (Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
//            Intent mIntent = new Intent(context, MainActivity.class);
//            mIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            context.startActivity(mIntent);
//        }
//    }
//        private static void changeBootStateReceiver(Context context, boolean enable) {
//        ComponentName receiver = new ComponentName(context, BootCompletedReceiver.class);
//        PackageManager pm = context.getPackageManager();
//
//        pm.setComponentEnabledSetting(receiver,
//                enable ? PackageManager.COMPONENT_ENABLED_STATE_ENABLED
//                        : PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
//                PackageManager.DONT_KILL_APP);
//    }
}