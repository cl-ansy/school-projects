package com.ood.blackjack;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Score {

	private int score;
	private String datePlayed;
	
	// Constructor used to insert a new score into the database
	public Score(int score) {
		this.setScore(score);
		
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yy hh:mm aa");
		Date now = new Date();
		setDatePlayed(sdf.format(now));
	}
	
	// Constructor used to retrieve a score stored in the database
	public Score() {
		
	}

	public int getScore() {
		return score;
	}

	public void setScore(int score) {
		this.score = score;
	}

	public String getDatePlayed() {
		return datePlayed;
	}

	public void setDatePlayed(String datePlayed) {
		this.datePlayed = datePlayed;
	}
	
}
