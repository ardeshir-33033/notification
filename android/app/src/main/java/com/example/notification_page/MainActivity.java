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
}