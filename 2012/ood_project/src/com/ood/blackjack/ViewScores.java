package com.ood.blackjack;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import android.os.Bundle;
import android.app.ListActivity;
import android.view.MenuItem;
import android.widget.ArrayAdapter;
import android.support.v4.app.NavUtils;

public class ViewScores extends ListActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.view_scores);
		
		ArrayAdapter<String> adapter = new ArrayAdapter<String>(this,
				android.R.layout.simple_list_item_1, getTopScores());
		setListAdapter(adapter);
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
	
	private String[] getTopScores() {
		ScoresAdapter db = new ScoresAdapter(this);
		ArrayList<Score> scoresArrayList = db.getScores(10);
		
		// Make sure this has at least a size of 1 so that we can tell the user no scores have been recorded.
		String[] returnValue = new String[scoresArrayList.size() > 0 ? scoresArrayList.size() : 1];
		
		for (int i = 0; i < scoresArrayList.size(); i++) {
			returnValue[i] = (i+1) + ". " + scoresArrayList.get(i).getScore() + " - " + scoresArrayList.get(i).getDatePlayed();
		}
		
		if (scoresArrayList.size() < 1)
			returnValue[0] = "No scores recorded.";
		
		return returnValue;
	}

}
