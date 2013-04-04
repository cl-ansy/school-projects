package com.ood.blackjack.Game;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Scanner;

import com.ood.blackjack.Rules.*;
import com.ood.blackjack.User.*;

public class Game implements Serializable{
	//Scanner for testing purposes for input
	//Private Variables for internal design
	private Scanner scan = new Scanner(System.in);
	private Dealer dealer;
	private Player player;
	private ArrayList<Participant> participants;
	private int gameID;
	private int tableID;
	private int blindAmount;
	private Deck deck;
	private boolean isGameOver = false;
	public static int NUM_CARDS=52;
	//ID's for dealing with whose turn it is. 
	private static Card[] dealtCards;
	private static int cardAmount;
	public boolean isFirstdeal=true;
	
	//Game Logic Elements
	private static final int WIN_SCORE=21;
	
	public static enum GAME_STATES 
	{
		start, resume, end
	}
	
	public static enum GAME_INPUT_MODE
	{
		paused, running
	}
	
	
	//Player Logic Elements
	//Game Logic Elements

	
	//Dealer AI Elements
	
	
	public Game()
	{
		participants = new ArrayList<Participant>();
	}
	
	Game(Dealer d, Player p)
	{
		dealer = d;
		player = p;

	}
	/**
	 * Methods for accessing data of the game file
	 * 
	 */
	public void setGameIsOver()
	{
		isGameOver = true;
	}
	
	public boolean gameOver()
	{
		return isGameOver;
	}
	public void setBlindAmount(int amount)
	{
		blindAmount = amount;
	}
	
	public int getBlindAmount()
	{
		return blindAmount;
	}
	public boolean isDeckEmpty()
	{
		boolean isEmpty=false;
		if(deck.count()==0)
		{
			isEmpty=true;
		}
		return isEmpty;
	}
	
	public void determineWinner()
	{
		
	}
	
	public void beginRound()
	{
		dealer.setNotDealerTurn();
		player.setPlayerTurn();
		player.subtractMoney(player.getBidAmount());
		
		dealer.firstDeal(player, this);
	}
	
	public boolean startDealerTurn()
	{
		player.setNotPlayerTurn();
		player.setTurnDone();
		dealer.setDealerTurn();
		dealer.setTurnStart();
		System.out.println("Dealer is making their Moves");
		//MakeMove plays up until either he busts or stands. 
		//dealer.makeMove(this);
		DealerMoves.makeMoves(dealer, this);
		//Set dealers turn to be over to finish the loop of the round.
		dealer.setNotDealerTurn();
		dealer.setTurnDone();
		return isPlayerVictory();
	}
	
	public boolean isPlayerVictory()
	{
		//WIN CONDITIONAL STATEMENTS
		Hand d_h = dealer.gethandFromList(0);
		Hand p_h = player.gethandFromList(0);
		
		if(!dealer.isWinner())
		{
			if(d_h.isHandOver() && p_h.isHandOver())
			{
				dealer.setAsWinner();
			}
			else if(d_h.getHandValue() == p_h.getHandValue())
			{
				player.setAsWinner();
			}
			else if(d_h.isHandOver() && !p_h.isHandOver())
			{
				player.setAsWinner();
			}
			else if(p_h.isHandOver() && !d_h.isHandOver())
			{
				dealer.setAsWinner();
			}
			else if(d_h.getHandValue() > p_h.getHandValue() && !d_h.isHandOver())
			{
				dealer.setAsWinner();
			}
			else if(p_h.getHandValue() > d_h.getHandValue() && !p_h.isHandOver())
			{
				player.setAsWinner();
			}
		}
		//-------------------------------------------------------------------------------
		//Output of winner based no WIN CONDITIONALS
		if(dealer.isWinner() && !player.isWinner())
		{
			System.out.println("Dealer Wins");
			dealer.resetWinner();
			return false;
		}
		else if(player.isWinner() && !dealer.isWinner())
		{
			System.out.println("Player Wins");
			player.addMoney(player.getBidAmount() * 2);
			player.resetWinner();
			return true;
		}
		
		System.out.println("ERRORERRORERROR");
		return false;
	}
	
	//This is basically one game...one round that determines the final hand of each player.
	//This is where we determine the overall winner of the game by the values of the hands.
	public void playRound()
	{
		//Set Player to play first after the inidial deal
		dealer.setNotDealerTurn();
		player.setPlayerTurn();
		//-----------------------------------------------
		//Deal the initial cards
		dealer.firstDeal(player, this);
		//-----------------------------------------------
		//While it is either the player or dealers turn, do this.
		while(dealer.isDealerTurn() || player.isPlayerTurn())
		{
			//If its the player turn.
			if(player.isPlayerTurn())
			{
				System.out.println("Player is making their moves");
				while(!player.IsTurnDone())
				{
					player.setTurnStart();
//					while(player.getHand().getHandValue() < 17)
//					{
					//Determine the move to make if the hand is under 17, this is our form of AI for testing.
					System.out.println("Hand before determing move: " + player.gethandFromList(0).getHandValue());
					PlayerMoves.determineMove(player, this);
//					}
					//When finished, set players turn to be over and the dealers turn so we can play the dealer now.
					player.setNotPlayerTurn();
					player.setTurnDone();
					dealer.setDealerTurn();
				}
			}
			else if(dealer.isDealerTurn())
			{
				dealer.setTurnStart();
				System.out.println("Dealer is making their Moves");
				//MakeMove plays up until either he busts or stands. 
				//dealer.makeMove(this);
				DealerMoves.makeMoves(dealer, this);
				//Set dealers turn to be over to finish the loop of the round.
				dealer.setNotDealerTurn();
				dealer.setTurnDone();
			}
	
		}
		for(Hand h : dealer.getHandList())
			System.out.println("Dealers Hand Value: " + h.getHandValue());
		for(Hand h : player.getHandList()){
			System.out.println("Players Hand Value: " + h.getHandValue());
		}
//		for(int i=0;i<=player.getHandList().size()-1;i++)
//		{
//			System.out.println("Players Hand "+ i + " : " + player.gethandFromList(i).getHandValue());
//		}
		//WIN CONDITIONAL STATEMENTS
		for(Hand d_h : dealer.getHandList())
		{
			for(Hand p_h : player.getHandList())
			{
				if(d_h.isHandOver() && p_h.isHandOver())
				{
					dealer.setAsWinner();
				}
				if(d_h.getHandValue() == p_h.getHandValue())
				{
					player.setAsWinner();
				}
				if(d_h.isHandOver())
				{
					player.setAsWinner();
				}
				else if(p_h.isHandOver())
				{
					dealer.setAsWinner();
				}
				if(d_h.getHandValue() > p_h.getHandValue() && !d_h.isHandOver())
					{
						dealer.setAsWinner();
					}
				else if(p_h.getHandValue() > d_h.getHandValue() && !p_h.isHandOver())
				{
					player.setAsWinner();
		
				}
			}
		}
		//-------------------------------------------------------------------------------
		//Output of winner based no WIN CONDITIONALS
		if(dealer.isWinner())
		{
			System.out.println("Dealer Wins");
			player.subtractMoney(player.getBidAmount());
		}
		else if(player.isWinner())
		{
			System.out.println("Player Wins");
			player.addMoney(player.getBidAmount() * 2);
		}
		//Reset the hands for the next round
		player.getHand().reset();
		dealer.getHand().reset();
	}
//-----------------------------------------------------------------------------------------------------------------------

	//used if we have more than one player playing with a dealer
	//DON'T USE THIS RIGHT NOW
	public void addPlayer(Participant player)
	{
		participants.add(player);
	}
	
	//sets the dealer of the game, the opponent of the player
	public void setDealer(Dealer d)
	{
		dealer = d;
	}
	
	//returns the dealer
	public Dealer getDealer()
	{
		return dealer;
	}
	
	public Hand getDealerHand()
	{
		return dealer.getHand();
	}
	
	public void setDeck(Deck d)
	{
		deck = d;
	}
	
	public int getTableID()
	{
		int temp = tableID;
		return temp;
	}
	
	public void setTableID(int id)
	{
		tableID = id;
	}
	
	public int getGameID()
	{
		int temp = gameID;
		return temp;
	}
	
	//sets current player of the game, opponent of dealer
	public void setPlayer(Player p)
	{
		player = p;
		player.setHand(p.getHand());
	}
	
	//returns the player if needed
	public Player getPlayer()
	{
		Player temp = player;
		return temp;
	}
	
	public Hand getPlayerHand()
	{
		return player.getHand();
	}
	
	//calls deck.shuffle to shuffle the decks cards.
	public void shuffleDeck()
	{
		deck.shuffle();
	}
	
	// returns the deck to access its methods
	public Deck getDeck()
	{
		Deck temp = deck;
		return temp;
	}
	
	//creates a new deck
	public void useNewDeck()
	{
		deck = new Deck();
	}
	
	

}
