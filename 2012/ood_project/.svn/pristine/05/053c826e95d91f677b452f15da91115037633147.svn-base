package com.ood.blackjack;

import java.util.HashMap;

import com.ood.blackjack.Game.*;
import com.ood.blackjack.Rules.*;
import com.ood.blackjack.User.*;

import android.os.Bundle;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.view.Gravity;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.TextView;
import android.support.v4.app.NavUtils;

public class GameUI extends Activity {

	private HashMap<String, Integer> cardMap;
	private Button stand, hit;
	private LinearLayout hand, dealer, handOverflow, dealerOverflow;
	private TextView handValue, score, bid;
	private Game g;
	private Dealer d;
	private Player p;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.game_ui);
		
		hand = (LinearLayout) findViewById(R.id.playerHand);
		handOverflow = (LinearLayout) findViewById(R.id.playerHandOverflow);
		handValue = (TextView) findViewById(R.id.handValue);
		dealer = (LinearLayout) findViewById(R.id.dealerHand);
		dealerOverflow = (LinearLayout) findViewById(R.id.dealerHandOverflow);
		score = (TextView) findViewById(R.id.ScoreText);
		bid = (TextView) findViewById(R.id.CurrentBid);
		
		stand = (Button) findViewById(R.id.Stand);
		stand.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				checkVictory();
			}
		});
		hit = (Button) findViewById(R.id.Hit);
		hit.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				PlayerMoves.hitPerHand(p, p.gethandFromList(0), g);
				getHand();
				handValue.setText("Hand Value: " + p.gethandFromList(0).getHandValue());
				if (p.gethandFromList(0).getHandValue() >= 21)
					checkVictory();
			}
		});
		
		cardMap = getCardMap();

		GameManager gm = new HighBidGame();
		p = new Player();
		d = new Dealer();
		d.setGameBuilder(gm);
		d.constructGame();
		g = d.getGame();

		g.setDealer(d);
		g.setPlayer(p);

		g.getPlayer().addMoney(1000);
		g.getDealer().addMoney(1000);
		score.setText("Score: " + g.getPlayer().getMoney());
		setBid();
	}
	
	private void getDealerHand(boolean expose) {
		dealer.removeAllViews();
		dealerOverflow.removeAllViews();
		LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		params.setMargins(10, 0, 10, 0);
		if (expose) {
			for (int i = 0; i < d.gethandFromList(0).cardCount(); i++) {
				Card c = d.gethandFromList(0).getCard(i);
				ImageView v = new ImageView(this);
				v.setLayoutParams(params);
				v.setImageResource(cardMap.get(c.getPngName()));
				if (i >= 4) {
					dealerOverflow.addView(v);
				} else
					dealer.addView(v);
			}
		} else {
			Card c = d.gethandFromList(0).getCard(0);
			ImageView v1 = new ImageView(this);
			v1.setLayoutParams(params);
			v1.setImageResource(cardMap.get(c.getPngName()));
			dealer.addView(v1);
			ImageView v2 = new ImageView(this);
			v2.setLayoutParams(params);
			v2.setImageResource(R.drawable.hidden);
			dealer.addView(v2);
		}
	}
	
	private void getHand() {
		hand.removeAllViews();
		handOverflow.removeAllViews();
		LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		params.setMargins(10, 0, 10, 0);
		for (int i = 0; i < p.gethandFromList(0).cardCount(); i++) {
			Card c = p.gethandFromList(0).getCard(i);
			ImageView v = new ImageView(this);
			v.setLayoutParams(params);
			v.setImageResource(cardMap.get(c.getPngName()));
			if (i >= 4) {
				handOverflow.addView(v);
			} else
				hand.addView(v);
		}
	}
	
	private void checkVictory() {
	    Builder builder = new AlertDialog.Builder(this);
	    boolean playerWins;
	    if (p.gethandFromList(0).getHandValue() > 21)
	    	playerWins = false;
	    else if (PlayerMoves.checkBlackjack(p) || g.startDealerTurn())
	    	playerWins = true;
	    else
	    	playerWins = false;
		getDealerHand(true);
		score.setText("Score: " + g.getPlayer().getMoney());
	    builder.setTitle(playerWins ? "Player wins!" : "Dealer wins.");
	    String msg = "Dealer: " + d.gethandFromList(0).getHandValue() +
	    			"\nPlayer: " + p.gethandFromList(0).getHandValue();
		if (g.getPlayer().getMoney() < 1)
			msg += "\n\nGame Over.";
	    builder.setMessage(msg);
		System.out.println("Dealer: " + d.gethandFromList(0).getHandValue() + ", Player: " + p.gethandFromList(0).getHandValue());
		if (g.getPlayer().getMoney() > 0) {
			builder.setPositiveButton("Next Round", new DialogInterface.OnClickListener() {
				@Override
				public void onClick(DialogInterface dialog, int which) {
					p.gethandFromList(0).reset();
					d.gethandFromList(0).reset();
					setBid();
				}
			});
		}
	    builder.setNegativeButton("Quit", new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				if (p.getMoney() > 0) {
					ScoresAdapter db = new ScoresAdapter(GameUI.this);
					db.addScore(new Score(p.getMoney()));
				}
				finish();
			}
	    });
	    builder.setCancelable(false);
	    builder.show();
	}
	
	private void setBid() {
		Builder builder = new AlertDialog.Builder(this);		
		builder.setTitle("Set bid amount");
		final TextView progressText = new TextView(this);
		progressText.setText(Integer.toString(g.getPlayer().getMoney() > 1000 ? 1000 : g.getPlayer().getMoney()));
		LinearLayout layout = new LinearLayout(this);
		layout.setOrientation(LinearLayout.VERTICAL);
		layout.setGravity(Gravity.CENTER);
		final SeekBar sb = new SeekBar(this);
		sb.setMax(g.getPlayer().getMoney());
		sb.setProgress(g.getPlayer().getMoney() > 1000 ? 1000 : g.getPlayer().getMoney());
		sb.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {
			@Override
			public void onProgressChanged(SeekBar seekBar, int progress,
					boolean fromUser) {
				progressText.setText(Integer.toString(progress));
			}

			@Override
			public void onStartTrackingTouch(SeekBar seekBar) { }

			@Override
			public void onStopTrackingTouch(SeekBar seekBar) { }
		});
		layout.addView(sb);
		layout.addView(progressText);
		builder.setView(layout);
		builder.setPositiveButton("Set", new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				g.getPlayer().setBidAmount(sb.getProgress());
				bid.setText("Current bid: " + p.getBidAmount());
				g.beginRound();
				getHand();
				handValue.setText("Hand Value: " + p.gethandFromList(0).getHandValue());
				getDealerHand(false);
				p.setTurnStart();
			}
		});
		builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
			@Override
			public void onClick(DialogInterface dialog, int which) {
				ScoresAdapter db = new ScoresAdapter(GameUI.this);
				db.addScore(new Score(p.getMoney()));
				finish();
			}
		});
		builder.setCancelable(false);
		builder.show();
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
	
	private HashMap<String, Integer> getCardMap() {
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		// Spades
		map.put("s_1", R.drawable.sa);
		map.put("s_2", R.drawable.s2);
		map.put("s_3", R.drawable.s3);
		map.put("s_4", R.drawable.s4);
		map.put("s_5", R.drawable.s5);
		map.put("s_6", R.drawable.s6);
		map.put("s_7", R.drawable.s7);
		map.put("s_8", R.drawable.s8);
		map.put("s_9", R.drawable.s9);
		map.put("s_t", R.drawable.s10);
		map.put("s_j", R.drawable.sj);
		map.put("s_q", R.drawable.sq);
		map.put("s_k", R.drawable.sk);
		
		// Hearts
		map.put("h_1", R.drawable.ha);
		map.put("h_2", R.drawable.h2);
		map.put("h_3", R.drawable.h3);
		map.put("h_4", R.drawable.h4);
		map.put("h_5", R.drawable.h5);
		map.put("h_6", R.drawable.h6);
		map.put("h_7", R.drawable.h7);
		map.put("h_8", R.drawable.h8);
		map.put("h_9", R.drawable.h9);
		map.put("h_t", R.drawable.h10);
		map.put("h_j", R.drawable.hj);
		map.put("h_q", R.drawable.hq);
		map.put("h_k", R.drawable.hk);
		
		// Clubs
		map.put("c_1", R.drawable.ca);
		map.put("c_2", R.drawable.c2);
		map.put("c_3", R.drawable.c3);
		map.put("c_4", R.drawable.c4);
		map.put("c_5", R.drawable.c5);
		map.put("c_6", R.drawable.c6);
		map.put("c_7", R.drawable.c7);
		map.put("c_8", R.drawable.c8);
		map.put("c_9", R.drawable.c9);
		map.put("c_t", R.drawable.c10);
		map.put("c_j", R.drawable.cj);
		map.put("c_q", R.drawable.cq);
		map.put("c_k", R.drawable.ck);
		
		// Diamonds
		map.put("d_1", R.drawable.da);
		map.put("d_2", R.drawable.d2);
		map.put("d_3", R.drawable.d3);
		map.put("d_4", R.drawable.d4);
		map.put("d_5", R.drawable.d5);
		map.put("d_6", R.drawable.d6);
		map.put("d_7", R.drawable.d7);
		map.put("d_8", R.drawable.d8);
		map.put("d_9", R.drawable.d9);
		map.put("d_t", R.drawable.d10);
		map.put("d_j", R.drawable.dj);
		map.put("d_q", R.drawable.dq);
		map.put("d_k", R.drawable.dk);
		
		return map;
	}

}
