package com.ood.blackjack.Game;

import com.ood.blackjack.Game.*;
import com.ood.blackjack.User.*;
import com.ood.blackjack.Rules.*;

public class DealerMoves extends Moves {
	DealerHand hand = new DealerHand();
	Game currentgame;
	
	public static void hit(Dealer d,Game game){
		//dealer hits if hand score is lower than 17
			System.out.println("hitting");
			d.getHand().addCard(game.getDeck().peekTopCard());
			System.out.println(d.getHand().getHandValue());
			// If deck is empty, when you pop another card it will automatically reload. 
			//add random card to hand
			
	}
	
	public static void hitPerHand(Hand h, Game g)
	{
		System.out.println("Hitting Dealer Per Hand");
		h.addCard(g.getDeck().popTopCard());
	}
	
	public static void stand(Dealer d){
		//dealer stands if hand score is 17 or above
			System.out.println("Standing For Dealer");
			DealerMoves.checkBust(d);
			//end turn
	}
	
	public static void standPerhand(Hand h)
	{
		h.setHandIsFinal(true);
	}
	
	public static void split(Dealer d) {
		d.getHand().split();
	}
	
	public static void checkHandValues(Dealer d)
	{
		for(int i=0;i<=d.getHandList().size()-1;i++)
		{
			Hand h = d.gethandFromList(i);
			System.out.println("Hand Value for Hand " + i+": "+ h.getHandValue());
		}
	}
	public static void makeMove(Dealer d,Game g)
	{
		//d.setDealerTurn();
		DealerMoves.checkHandValues(d);
		System.out.println("Checking for ace,and blackjack first");
		//Checking for an ace on initial deal, 
		//checkForAce also calls setAce to 11 for dealer because DealerHand overwrites Hand setAceToEleven
		d.getHand().checkForAce();
		d.getHand().checkBlackJack();
		while(d.isDealerTurn() && !d.IsTurnDone())
		{
			System.out.println("Loop Iteration");
			if(d.getHand().getHandValue() < 17)
			{
				System.out.println("hitting < 17");
				DealerMoves.hit(d, g);
				d.getHand().checkForAce();
				DealerMoves.checkBust(d);
			}
			else if(d.getHand().getHandValue() >= 17)
			{
				System.out.println("hitting >=17");
				DealerMoves.stand(d);
				d.setNotDealerTurn();
				d.setTurnDone();
			}
		}
	}
	
	//METHOD USED FOR HANDLIST,THIS IS USED NOW DUE TO MULTIPLE HAND POSSIBLITIES
	public static void makeMoves(Dealer d, Game g)
	{
		DealerMoves.checkHandValues(d);		//Print out hand Values of the dealer, One hand if no split
		System.out.println("Check For Blackjack, then an Ace to determine if it should be 11 or 1");
		
		if(DealerMoves.checkBlackjack(d))
		{
			System.out.println("BlackJack is true,so we set dealers turn done before he has to make a move");
			d.setNotDealerTurn();
			d.setTurnDone();
		}
		while(d.isDealerTurn() && !d.IsTurnDone())
		{
			
			System.out.println("Performing a move:");
			for(int i = 0;i<=d.getHandList().size()-1;i++)
			{
				Hand h =d.gethandFromList(i);
				while(h.getHandValue() < 17)
				{
					System.out.println("Hand is < 17");
					DealerMoves.hitPerHand(h, g);
					
				}
				if(h.getHandValue() >= 17)
				{
					System.out.println("Dealer Hand is >= 17");
					DealerMoves.standPerhand(h);
				}
			}
			DealerMoves.checkBust(d);	//CheckBust removes any hands that have bust, this allows determining a winner easier, as we don't need busted hands.
			if(d.allhandsFinal())
			{
				System.out.println("All hands are final, setting dealer turn as over");
				d.setTurnDone();
				d.setNotDealerTurn();
				break;
			}
		}
	}
}

