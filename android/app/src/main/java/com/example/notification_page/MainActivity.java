package com.example.notification_page;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity{
    private Intent service;

    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(new FlutterEngine(this));

        service = new Intent(MainActivity.this, MyService.class);

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            startForegroundService(service);
        }
        else{
            startService(service);
        }
    }
}