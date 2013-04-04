package com.ood.blackjack.Game;
import java.util.ArrayList;


import com.ood.blackjack.Rules.*;
import com.ood.blackjack.User.Player;

public class PlayerMoves extends Moves {
	
	static ArrayList<Hand> hands = new ArrayList<Hand>();

	//DONT USE THESE--------------------------------------------
	public static void hit(Player p,Game currentgame){
		//if current deck is empty, create a new one
		for(Hand h : p.getHandList())
		{
		if(h.getHandValue() < 17)
			h.addCard(currentgame.getDeck().popTopCard());
		}
	}
	
	public static void stand(Player p){
		//calculate hand score
		for(Hand h : p.getHandList())
		{
			if(h.getHandValue() >=17)
			{
			p.addScore(2*h.getHandValue());
			h.setHandIsFinal(true);
			//end turn
			}
		}
	}
	//----------------------------------------------------------
	
	//USE THESE INSTEAD,WORK GREAT FOR INDIVIDUAL HANDS
	public static void hitPerHand(Player p,Hand h, Game currentgame)
	{
		h.addCard(currentgame.getDeck().popTopCard());
	}
	
	public static void standPerHand(Player p,Hand h)
	{
		p.addScore(h.getHandValue());
		h.setHandIsFinal(true);
	}
	//-----------------------------------------------------------
	
	public static void checkHandValues(Player p)
	{
		for(int i=0;i<=p.getHandList().size()-1;i++)
		{
			Hand h = p.gethandFromList(i);
			System.out.println("Hand Value for Hand " + i+": "+ h.getHandValue());
		}
	}
	
	public static void determineMoves(Player p, Game currentgame)
	{
		System.out.println("Player is determining their Moves");
		//when you determine a move, you first check for blackjack, if blackjack
		//The first thing you do when you get your hand is check for blackjack
//		if(p.getHand().checkBlackJack())
//		{
//			p.setTurnDone();
//		}
		//CheckBlackJack first because we need to know to stop their turn now or not. 
		PlayerMoves.checkBlackjack(p);
		while(p.isPlayerTurn() && !p.IsTurnDone())
		{
			System.out.println("Number of Hands: " + p.getHandList().size());
			if(p.getHand().canSplit())
			{
				split(p,p.getHand());
				for(Hand h : p.getHandList())
				{
					if(h.canSplit())
					{
						split(p,h);
					}
					if(h.checkBlackJack())
					{
						p.setTurnDone();
						p.setNotPlayerTurn();
					}
					if(h.getHandValue() >=17)
					{
						stand(p);
						PlayerMoves.checkBust(p);
						PlayerMoves.checkBlackjack(p);
					}
					if(h.getHandValue() < 17)
					{
						hitPerHand(p,h,currentgame);
					}
				}		
				
			}
			else
			{
				if(p.getHand().getHandValue() >= 17)
				{
					stand(p);
					PlayerMoves.checkBust(p);
					PlayerMoves.checkBlackjack(p);
				}
				else if(p.getHand().getHandValue() < 17)
				{
					hit(p,currentgame);
					p.getHand().checkBlackJack();
					PlayerMoves.checkBust(p);
					PlayerMoves.checkBlackjack(p);
				}
			}
		}
	}

	public static void determineMove(Player p, Game currentgame)
	{
		System.out.println("Determing moves for players hands\n");
		while(p.isPlayerTurn() && !p.IsTurnDone())
		{
			PlayerMoves.checkHandValues(p);
			if(PlayerMoves.checkBlackjack(p))
			{
				System.out.println("Player has Blackjack, ending turn\n");
				p.setAsWinner();
				p.setTurnDone();
				p.setNotPlayerTurn();
				break;
			}
			if(PlayerMoves.checkTwentyOne(p))
			{
				System.out.println("Player has twentyone, ending turn\n");
				p.setNotPlayerTurn();
				p.setTurnDone();
				break;
			}
			
			for(int i =0;i<=p.getHandList().size()-1;i++)
			{
				System.out.println("Making Player Move: \n");
				Hand h = p.gethandFromList(i);
				if(h.canSplit())
				{
					System.out.println("Splitting Player Hand");
					PlayerMoves.split(p,h);
				}
				if(h.getHandValue() < 17)
				{
					System.out.println("Hitting Player Hand");
					PlayerMoves.hitPerHand(p, h, currentgame);
				}
				if(h.getHandValue() >= 17)
				{
					System.out.println("Standing on Player Hand");
					PlayerMoves.standPerHand(p,h);
				}
			}
			PlayerMoves.checkHandValues(p);
			if(p.allhandsFinal())
			{
				System.out.println("All Hands are final, Setting player turn as over\n");
				p.setNotPlayerTurn();
				p.setTurnDone();
				break;
			}
//			for(Hand h : p.getHandList())
//			{
//				System.out.println("Hand Value: " + h.getHandValue());
//				if(h.canSplit())
//				{
//					System.out.println("Hand Can Split");
//					split(p,h);
//				}
//				while(h.getHandValue() < 17)
//				{
//					System.out.println("Hand is less than 17");
//					if(h.getHandValue() < 17)
//					{
//						System.out.println("Hitting Player Hand, hitPerHand()");
//						System.out.println("Hand Value: " + h.getHandValue());
//
//						hitPerHand(p,h,currentgame);
//					}
//					if(h.getHandValue() >=17)
//					{
//						System.out.println("hand is larger than 17, now we stand for this hand");
//						System.out.println("Hand Value: " + h.getHandValue());
//						standPerHand(p,h);
//						h.setHandIsFinal(true);
//						break;
//					}
//				}	
//			}
			PlayerMoves.split(p);
			PlayerMoves.hit(p, currentgame);
			PlayerMoves.stand(p);
			if(p.allhandsFinal())
			{
				p.setTurnDone();
				p.setNotPlayerTurn();
			}
			PlayerMoves.checkBust(p);
			PlayerMoves.checkTwentyOne(p);
		}
		
	}
}
