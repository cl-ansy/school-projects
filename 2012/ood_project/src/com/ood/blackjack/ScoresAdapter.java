package com.ood.blackjack;

import java.util.ArrayList;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class ScoresAdapter extends SQLiteOpenHelper {

	public static final String DATABASE_NAME = "BlackjackScores";
    public static final int DATABASE_VERSION = 1;
    
    public static final String TABLE_SCORES = "Scores";
    
    public static final String KEY_ID = "ID";
    public static final String KEY_SCORE = "Score";
    public static final String KEY_DATE = "DatePlayed";
    
    public static final String CREATE_SCORES_TABLE = "CREATE TABLE " + TABLE_SCORES + "("
    		+ KEY_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
    		+ KEY_SCORE + " INTEGER NOT NULL, "
    		+ KEY_DATE + " TEXT NOT NULL);";
    
    public ScoresAdapter(Context context) {
    	super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
    	db.execSQL(CREATE_SCORES_TABLE);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
    	// Make upgrade changes here
    }
    
    public void addScore(Score score) {
    	SQLiteDatabase db = getWritableDatabase();
    	
    	ContentValues values = new ContentValues();
    	values.put(KEY_SCORE, score.getScore());
    	values.put(KEY_DATE, score.getDatePlayed());
    	
    	db.insert(TABLE_SCORES, null, values);
    	db.close();
    }
    
    // Retrieves the specified number of scores. If count == 0, retrieves all scores. If count < 0, retrieves no scores.
    public ArrayList<Score> getScores(int count) {
    	ArrayList<Score> scoreList = new ArrayList<Score>();
    	String selectQuery = "SELECT * FROM " + TABLE_SCORES + " ORDER BY " + KEY_SCORE + " DESC";
    	
    	SQLiteDatabase db = getWritableDatabase();
    	Cursor cursor = db.rawQuery(selectQuery, null);
    	
    	if (cursor.moveToFirst()) {
    		int index = count > 0 ? 0 : -1;
    		do {
    			if (count > 0)
    				index++;
    			Score score = new Score();
    			score.setScore(cursor.getInt(cursor.getColumnIndex(KEY_SCORE)));
    			score.setDatePlayed(cursor.getString(cursor.getColumnIndex(KEY_DATE)));
    			
    			scoreList.add(score);
    		} while (cursor.moveToNext() && index < count);
    	}
    	cursor.close();
    	db.close();
    	
    	return scoreList;
    }
    
    public void clearScores() {
            SQLiteDatabase db = getWritableDatabase();
            db.delete(TABLE_SCORES, null, null);
            db.close();
    }
    
}