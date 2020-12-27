package com.example.notification_page;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.List;

public class DbManager {
    DbHelper myhelper;
    Gson gson;
    public DbManager(Context context)
    {
        myhelper = new DbHelper(context);
        gson = new Gson();
    }

    public long insertData(String app, String user, String message)
    {
        SQLiteDatabase dbb = myhelper.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put("app", app);
        contentValues.put("user", user);
        contentValues.put("message", message);
        long id = dbb.insert(DbHelper.TABLE_NAME, null , contentValues);
        return id;
    }

    public List<UserMessageModel1> getData()
    {
        List<UserMessageModel1> items = new ArrayList<>();

        SQLiteDatabase db = myhelper.getWritableDatabase();
        String[] columns = {"id", "app", "user", "message"};
        Cursor cursor =db.query(DbHelper.TABLE_NAME,columns,null,null,null,null,null);
        StringBuffer buffer= new StringBuffer();
        while (cursor.moveToNext())
        {
            int cid =cursor.getInt(cursor.getColumnIndex("id"));
            //String name =cursor.getString(cursor.getColumnIndex("app"));
            //String  password =cursor.getString(cursor.getColumnIndex("user"));
            String  message = cursor.getString(cursor.getColumnIndex("message"));
            //buffer = buffer.append(message);
            items.add(gson.fromJson(message, UserMessageModel1.class));

        }
        return items;
    }

    public int delete(String id)
    {
        SQLiteDatabase db = myhelper.getWritableDatabase();
        String[] whereArgs ={id};

        int count =db.delete(DbHelper.TABLE_NAME , "id = ?",whereArgs);
        return  count;
    }

    static class DbHelper extends SQLiteOpenHelper
    {
        private static final String DATABASE_NAME = "manaDb";    // Database Name
        private static final String TABLE_NAME = "messages";   // Table Name
        private static final int DATABASE_Version = 1;    // Database Version
        //private static final String UID="id";     // Column I (Primary Key)
        //private static final String NAME = "Name";    //Column II
        //private static final String MyPASSWORD= "Password";    // Column III
        private static final String CREATE_TABLE = "CREATE TABLE "+TABLE_NAME+
                " (id INTEGER PRIMARY KEY AUTOINCREMENT, app VARCHAR(255) ,user VARCHAR(225), message TEXT);";
        private static final String DROP_TABLE ="DROP TABLE IF EXISTS "+TABLE_NAME;
        private Context context;

        public DbHelper(Context context) {
            super(context, DATABASE_NAME, null, DATABASE_Version);
            this.context=context;
        }

        public void onCreate(SQLiteDatabase db) {

            try {
                db.execSQL(CREATE_TABLE);
            } catch (Exception e) {
                //Message.mess(context,""+e);
            }
        }

        @Override
        public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
            try {
                //Message.message(context,"OnUpgrade");
                db.execSQL(DROP_TABLE);
                onCreate(db);
            }catch (Exception e) {
                //Message.message(context,""+e);
            }
        }
    }}
