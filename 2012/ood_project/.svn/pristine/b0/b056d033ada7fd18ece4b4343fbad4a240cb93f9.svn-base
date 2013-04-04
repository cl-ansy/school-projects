package com.ood.blackjack;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class UI extends Activity {
	
	private Button playBtn, viewScoresBtn, exitBtn, aboutBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ui);
        
        // Set button click listeners
        playBtn = (Button) findViewById(R.id.PlayGame);
        playBtn.setOnClickListener(btnListener);
        viewScoresBtn = (Button) findViewById(R.id.ViewScores);
        viewScoresBtn.setOnClickListener(btnListener);
        exitBtn = (Button) findViewById(R.id.Exit);
        exitBtn.setOnClickListener(btnListener);
        aboutBtn = (Button) findViewById(R.id.About);
        aboutBtn.setOnClickListener(btnListener);
        
        
    }
    
    private OnClickListener btnListener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.PlayGame:
				startActivity(new Intent(UI.this, GameUI.class));
				break;
			case R.id.ViewScores:
				startActivity(new Intent(UI.this, ViewScores.class));
				break;
			case R.id.Exit:
				finish();
				break;
			case R.id.About:
				startActivity(new Intent(UI.this, About.class));
				break;
			}
		}
    };
    
}
