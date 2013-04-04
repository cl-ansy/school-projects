package com.ood.blackjack.Rules;

import com.ood.blackjack.Rules.Hand;
import com.ood.blackjack.User.*;

//Moves should probably be called in Turn class
public abstract class Moves {
	
	public static void checkBust(Participant p){
		//if hand score > 21
			int bustCount=0;
		if(p.getHandList().size() == 1)
		{
			if(p.gethandFromList(0).isHandOver())
			{
				p.setTurnDone();
				p.subtractMoney(p.getBidAmount());
			}
		}
		else
		{
			for(int i=0;i<=p.getHandList().size()-1;i++)
			{
				Hand h = p.gethandFromList(i);
				if(h.isHandOver()){
					System.out.println("Bust");
					bustCount ++;
					p.removeHand(h);
					//	subtract the bid amount from the player. The default bid amount is set in the constructor and can be set. 
					
					//p.setTurnDone();
					//	end turn
				}
			}
		}
		if(bustCount == p.getHandList().size())
		{
			p.subtractScore(p.getBidAmount());
			p.subtractMoney(p.getBidAmount());
			p.setTurnDone();
		}
	}
	
	//Check for blackjack when called, if blackjack, the turn is done, and the winner is set.
	public static boolean checkBlackjack(Participant p){
		boolean isBlackJack=false;
		//if hand score = 21
		for(Hand h : p.getHandList())
		{
			if(h.checkBlackJack()){
				// add bet x 2 to score
				p.addScore(p.getBidAmount() * 2);
				p.setTurnDone();
				p.setAsWinner();
				isBlackJack=true;
				break;
				// end turn
			}
		}
		return isBlackJack;
	}
	
	//Check for twentyone throughout the game, after each move, we check for twentyone to determine if the turn should end. 
	public static boolean checkTwentyOne(Participant p)
	{
		boolean isTwentyOne=false;
		for(Hand h : p.getHandList())
		{
			if(h.getHandValue() == 21)
			{
				p.addMoney(p.getBidAmount());
				isTwentyOne=true;
				break;
			}
		}
		return isTwentyOne;
	}
	
	public static void split(Participant p, Hand h)
	{
		if(h.canSplit())
		{
			p.printHands();
			p.addHand(h.split());
			p.printHands();
		}
	}
	
	public static void split(Participant p)
	{
		for(int i=0;i<=p.getHandList().size()-1;i++)
		{
			Hand h = p.gethandFromList(i);
			if(h.canSplit()){
				p.addHand(h.split());
			}
		}
	}
}