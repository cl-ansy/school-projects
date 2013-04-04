package com.ood.blackjack.Game;
import java.util.ArrayList;
import java.util.Random;

import com.ood.blackjack.Rules.Deck;
import com.ood.blackjack.User.*;

public class HighBidGame extends GameManager {
	private Player player;
	private int bidAmount;
	private int blindAmount;
	private int gameID;
	private Deck deck;
	
	public HighBidGame()
	{
		blindAmount = 1000;
	}
	
	HighBidGame(int blind)
	{
		blindAmount = blind;
	}
	
	public void buildPlayers()
	{
		//set dealer and player in this method. 
		player = new Player();
		game.setPlayer(player);
	}

	public void buildRules()
	{
		game.setBlindAmount(blindAmount);
	}
	

	public void buildTable()
	{
		Random rand = new Random();
		game.setTableID(rand.nextInt());
		deck = new Deck();
		game.setDeck(deck);
	}

	public void syncDatabase()
	{
		
	}

}
