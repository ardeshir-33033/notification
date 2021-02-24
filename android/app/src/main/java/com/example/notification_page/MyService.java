package com.example.notification_page;

import android.app.NotificationManager;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.BatteryManager;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.microsoft.signalr.HubConnection;
import com.microsoft.signalr.HubConnectionBuilder;
import com.microsoft.signalr.HubConnectionState;

import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

public class MyService extends Service {
    String appName = "MANAGOSTAR_NOTIFICACTION";
    String userName ;
    String deviceName = "android_service";
    private HubConnection mHubConnection;
    Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX").create();
    private String tid;
    private Timer timer;
    private float percentage = 0;

    @Override
    public void onCreate() {
        super.onCreate();

        BroadcastReceiver mBatInfoReceiver = new BroadcastReceiver(){
            @Override
            public void onReceive(Context ctxt, Intent intent) {
                int level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
                int scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
                float batteryPct = level * 100 / (float)scale;

                if(percentage != 0 && percentage != batteryPct && batteryPct / 2 == 0){
                    SignalR();
                    percentage = batteryPct;
                }
            }
        };

        this.registerReceiver(mBatInfoReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            NotificationManager manager = getSystemService(NotificationManager.class);
            NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "mana_notifications")
                    .setContentText("سیستم مدیریت پیام های فوری")
                    .setContentTitle("مانا گستر آرا")
                    .setSmallIcon(R.drawable.tips)
                    .setLargeIcon(BitmapFactory.decodeResource(getResources(), R.drawable.tips));

            startForeground(100011, builder.build());
        }

        new Timer().schedule(new TimerTask() {
            @Override
            public void run() {
                try {
                    if (mHubConnection.getConnectionState() == HubConnectionState.CONNECTED) {
                        mHubConnection.invoke("StayLiveMessage", appName, userName, "i am alive");
                    }
                    else if(mHubConnection == null){
                        SignalR();
                    }
                    else {
                        mHubConnection.start().blockingAwait();
                    }
                } catch (Exception Ex) {
                    System.out.print(Ex);
                }
            }
        }, 0, 22000);

        new Timer().schedule(new TimerTask() {
            @Override
            public void run() {
                try {
                    if (mHubConnection.getConnectionState() == HubConnectionState.CONNECTED) {
                        mHubConnection.invoke("SendUnsendedMessages", appName, userName, deviceName);
                    }
                    else if(mHubConnection == null){
                        SignalR();
                    }
                    else {
                        mHubConnection.start().blockingAwait();
                    }
                } catch (Exception Ex) {
                    System.out.print(Ex);
                }
            }
        }, 0, 15000);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        try {
            userName = intent.getStringExtra("GUId");

            SignalR();

            return START_STICKY;
        }catch (Exception ex){
            System.out.print(ex);
        }
        return START_STICKY;
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    public void SignalR(){
        try{
            if(mHubConnection == null || (mHubConnection != null && mHubConnection.getConnectionState() != HubConnectionState.CONNECTED)) {
                mHubConnection = HubConnectionBuilder.create("https://signal.dinavision.org/chathub").build();

                mHubConnection.on("ReceiveDisconnectedMessage", (message) ->
                {
                    Log.d(">>>>>>>>>>", "DISCONNECTED");
                }, String.class);

                mHubConnection.on("ReceiveConnectedMessage", (message) ->
                {
                    mHubConnection.invoke("Init", appName, userName, mHubConnection.getConnectionId(), deviceName);
                }, String.class);

                mHubConnection.on("ReceiveUnReceivedMessages", (message) ->
                {
                    NotifMessages(message);
                }, String.class);

                mHubConnection.on("ReceiveMessage", (message) ->
                {
                    NotifMessage(message);
                }, String.class);

                mHubConnection.start().blockingAwait();
            }
        }catch (Exception ex){
            System.out.print(ex);
        }
    }

    private void NotifMessage(String message) {
        try {
            UserMessageModel1 model = gson.fromJson(message, UserMessageModel1.class);

            Bitmap myBitmap;

            if (model != null && model.icon == "it") {
                myBitmap = BitmapFactory.decodeResource(getResources(), R.drawable.circle);
            } else if (model != null && model.icon == "sales") {
                myBitmap = BitmapFactory.decodeResource(getResources(), R.drawable.square);
            } else if (model != null && model.icon == "warehouse") {
                myBitmap = BitmapFactory.decodeResource(getResources(), R.drawable.rectangle);
            } else if (model != null && model.icon == "accounting") {
                myBitmap = BitmapFactory.decodeResource(getResources(), R.drawable.star);
            } else {
                myBitmap = BitmapFactory.decodeResource(getResources(), R.drawable.tips);
            }

            NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "mana_notifications");
            builder.setContentText(model.message)
                    .setContentTitle(model.title)
                    .setSmallIcon(R.drawable.tips)
                    .setLargeIcon(myBitmap)
                    .build();

            NotificationManager Nmanager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);

            Nmanager.notify(model.identity, builder.build());

            // ارسال پیامی که دریافت شده است
            mHubConnection.invoke("SendRecivedMessage", model.app, model.user, model.identity);

            Log.d("@@@@@@@@@@@@@@@@@", "----------------------------------------------------------");
            Log.d(" ReceiveMessage -> ", message);
            Log.d("@@@@@@@@@@@@@@@@@", "----------------------------------------------------------");
        } catch (Exception ex) {
            Log.d("@@@@@@@@@@@@@@@@@", "---------------------------------------------------------");
            Log.d("RM ------------> ", ex.getMessage());
            Log.d("@@@@@@@@@@@@@@@@@", "---------------------------------------------------------");
        }
    }

    private void NotifMessages(String message) {
        try {
            List<UserMessageModel1> models = gson.fromJson(message, new TypeToken<List<UserMessageModel1>>(){}.getType());

            Bitmap myBitmap;

            for (UserMessageModel1 model : models) {
                if (model != null && model.icon == "it") {
                    myBitmap = BitmapFactory.decodeResource(getResources(), R.drawable.circle);
                } else if (model != null && model.icon == "sales") {
                    myBitmap = BitmapFactory.decodeResource(getResources(), R.drawable.square);
                } else if (model != null && model.icon == "warehouse") {
                    myBitmap = BitmapFactory.decodeResource(getResources(), R.drawable.rectangle);
                } else if (model != null && model.icon == "accounting") {
                    myBitmap = BitmapFactory.decodeResource(getResources(), R.drawable.star);
                } else {
                    myBitmap = BitmapFactory.decodeResource(getResources(), R.drawable.tips);
                }

                NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "mana_notifications");
                builder.setContentText(model.message)
                        .setContentTitle(model.title)
                        .setSmallIcon(R.drawable.tips)
                        .setLargeIcon(myBitmap)
                        .build();

                NotificationManager Nmanager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);

                Nmanager.notify(model.identity, builder.build());

                // ارسال پیامی که دریافت شده است
                mHubConnection.invoke("SendRecivedMessage", model.app, model.user, model.identity);
            }
            Log.d("@@@@@@@@@@@@@@@@@", "----------------------------------------------------------");
            Log.d(" ReceiveMessage -> ", message);
            Log.d("@@@@@@@@@@@@@@@@@", "----------------------------------------------------------");
        } catch (Exception ex) {
            Log.d("@@@@@@@@@@@@@@@@@", "---------------------------------------------------------");
            Log.d("RM ------------> ", ex.getMessage());
            Log.d("@@@@@@@@@@@@@@@@@", "---------------------------------------------------------");
        }
    }
}
