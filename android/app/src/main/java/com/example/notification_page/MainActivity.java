package com.example.notification_page;

import android.content.Intent;
import android.os.Bundle;
import android.os.Build;

import androidx.annotation.NonNull;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private Intent service;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(new FlutterEngine(this));

        service = new Intent(MainActivity.this, MyService.class);

//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            startForegroundService(service);
//        } else {
//            startService(service);
//        }

        new MethodChannel(getFlutterView() , "ardeshir").setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                String text = call.argument("text");

                if(call.method.equals("startService")){
                    service.putExtra("GUId", text);

                    startService();
                    result.success("Successful");
                }
            }
        });
    }

    private void startService(){
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            startForegroundService(service);
        } else {
            startService(service);
        }
    }

//          new MethodChannel(getFlutterView(),"com.retroportalstudio.messages")
//            .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
//        @Override
//        public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
//            String arg = methodCall.argument("tid");
//
//            tid = arg;
//            //Toast.makeText(getBaseContext(), "tid : " + arg, Toast.LENGTH_LONG).show();
//
//            SharedPreferences prefs = getSharedPreferences("taskmanagerplugin", MODE_PRIVATE);
//            SharedPreferences.Editor edt = prefs.edit();
//            edt.putString("tid", arg);
//            edt.commit();
//
//            String ddd = prefs.getString("tid", "======");
//            //Toast.makeText(getBaseContext(), ">>>> " + ddd, Toast.LENGTH_LONG).show();
//
//            if(methodCall.method.equals("startService")){
//                startService();
//                result.success("Service Started");
//            }
//        }
//    });

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