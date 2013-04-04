package com.ood.blackjack;

import android.os.Bundle;
import android.app.Activity;
import android.view.MenuItem;
import android.widget.TextView;
import android.support.v4.app.NavUtils;

public class About extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.about);
		
		TextView about = (TextView) findViewById(R.id.AboutContent);
		String aboutText = "CSCI 5335-A\n" +
				"Object-Oriented Design\n" +
				"Dr. Vladan Jovanovic\n\n" +
				"Mobile Blackjack Application Project\n\n" +
				"Team Members:\n" +
				"Justin Driggers\n" +
				"Brandon Jacobs\n" +
				"Chris Lansing\n" +
				"Traccy Scarboro";
		about.setText(aboutText);
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case android.R.id.home:
			NavUtils.navigateUpFromSameTask(this);
			return true;
		}
		return super.onOptionsItemSelected(item);
	}

}
