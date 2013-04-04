package com.ood.blackjack.Game;


import com.ood.blackjack.Rules.*;
import com.ood.blackjack.User.*;

//Director of the game, sets up the gameManager, the game, the rules, and initiates the game. The Dealer
// Class will be responsible for dealing the cards, and shuffling the deck through the game class. 
public class Dealer extends Participant{
	DealerHand hand;
	GameManager gameManager;
	private int dealerID = 0;
	private boolean isDealerTurn=false;
	//-----------------------------------------------
	//Builder Pattern creation 
	public void setGameBuilder(GameManager gm){ gameManager = gm;}
	public Game getGame(){ return gameManager.getGame();}
	
	
	public Dealer()
	{
		hand=new DealerHand();
	}
	
	public void constructGame()
	{
		gameManager.createNewGame();
		gameManager.buildPlayers();
		gameManager.buildRules();
		gameManager.buildTable();
		
	}
	
	//-----------------------------------------------
	//End Game Creation Builder Pattern 
	
	//Determines moves to make until they either stay with their hand, bust, or have blackjack.
	public void makeMove(Game g)
	{
		setDealerTurn();
		System.out.println("Checking for ace,and blackjack first");
		System.out.println("Hand Value: " + getHand().getHandValue());
		//Checking for an ace on initial deal, 
		//checkForAce also calls setAce to 11 for dealer because DealerHand overwrites Hand setAceToEleven
		getHand().checkBlackJack();
		getHand().checkForAce();
		while(isDealerTurn() && !IsTurnDone())
		{
			System.out.println("Loop through each of the hands in the handList of the player");
			for(Hand h : getHandList())
			{
				if(h.getHandValue() < 17)
				{
					System.out.println("hitting < 17");
					DealerMoves.hit(this, g);
					getHand().checkForAce();
					DealerMoves.checkBust(this);
				}
				else if(getHand().getHandValue() >= 17)
				{
					System.out.println("hitting >=17");
					DealerMoves.stand(this);
					setNotDealerTurn();
				}
			}
		}
	}
	
	public boolean isDealerTurn()
	{
		return isDealerTurn;
	}
	
	public void setNotDealerTurn()
	{
		isDealerTurn = false;
	}
	
	public void setDealerTurn()
	{
		isDealerTurn = true;
	}
	public int getDealerID()
	{
		return dealerID;
	}
	
	public DealerHand getHand()
	{
		return this.hand;
	}
	
	public void setHand(DealerHand d)
	{
		this.hand = d;
	}
	
	public void firstDeal(Player p, Game g) {
		//Deal two cards to the player.
		g.getDeck().shuffle();
		p.getHand().addCard(g.getDeck().popTopCard());
		p.getHand().addCard(g.getDeck().popTopCard());
		
		//Deal to the first hand in the handlist
		p.gethandFromList(0).addCard(g.getDeck().popTopCard());
		p.gethandFromList(0).addCard(g.getDeck().popTopCard());

		
		getHand().addCard(g.getDeck().popTopCard());
		getHand().addCard(g.getDeck().popTopCard());
		
		//Deal to the first hand in the handlist
		gethandFromList(0).addCard(g.getDeck().popTopCard());
		gethandFromList(0).addCard(g.getDeck().popTopCard());

	}
	
	//method is called to deal the card. 
//	public static void deal(Participant p, Game g)
//	{
//		p.getInitialHand().addCard(g.getDeck().popTopCard());
//	}

}
