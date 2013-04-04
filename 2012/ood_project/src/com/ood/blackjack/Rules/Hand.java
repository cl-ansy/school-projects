package com.ood.blackjack.Rules;

import java.util.ArrayList;
import java.util.Scanner;

public class Hand {
	protected ArrayList<Card> cards;
	protected ArrayList<Card> currentCards;
	protected ArrayList<Card> secondHandCards;
	private boolean canSplit=false;
	private boolean isSplit = false;
	public boolean isPlayer;
	public boolean isDealer;
	private boolean handIsFinal=false;
	
	public Hand()
	{
		reset();
	}
	
	public void addCard(Card c)
	{
		cards.add(c);
		currentCards.add(c);
	}
	
	public void discardHand()
	{
		reset();
	}
	
	public void reset()
	{
		cards = new ArrayList<Card>();
		currentCards= new ArrayList<Card>();
		secondHandCards = new ArrayList<Card>();
	}
	
	// returns true if is split
	public boolean IsSplit()
	{
		if(canSplit()) isSplit=true;
		return isSplit;
	}
	
	public int getHandValue()
	{
		int retVal=0;
		int aceCount = 0;
		for (Card c : currentCards)
		{
			if (c.getValue() == '1')
				aceCount++;
			retVal+=c.getCountValue();
		}
		
		while (retVal > 21 && aceCount > 0) {
			retVal -= 10;
			aceCount--;
		}
		
		return retVal;
	}
	
	public int cardCount()
	{
		int retVal=0;
		retVal = currentCards.size();
		return retVal;
	}
	
	public Card getCard(int index)
	{
		Card temp = currentCards.get(index);
		return temp;
	}
	
	public boolean checkForAce()
	{
		boolean isAce=false;
		for(Card c : currentCards)
		{
			if(c.getValue() == Card.ACE)
			{
				isAce = true;
				setAceAsEleven();
				
			}
		}
		return isAce;
	}
	
	//This value should either be 'f' for Eleven or '1' for basic value of one. 
	public void setAceAsEleven()
	{
		Scanner scan = new Scanner(System.in);
		for(Card c : currentCards)
		{
			if(c.getValue() == Card.ACE)
			{
				System.out.println("Would you like to set the ace to be woth 11?");
				System.out.println("If yes press y. If no press n.");
				if(scan.next().matches("y"))
				{
					c.setValue('f');
				}
				break;
			}
		}
	}
	
	public void printCards()
	{
		System.out.println("Current cards in Hand");
		System.out.println("---------------------");
		for(Card c : currentCards)
		{
			System.out.println(c.getSuit()+"_"+c.getValue());
		}
	}
	
	public boolean checkBlackJack()
	{
		boolean isBlackJack=false;
		for(Card c : currentCards)
		{
			if(c.getValue() == Card.JACK)
			{
				for(Card c1 : currentCards)
				{
					if(c1.getValue() == Card.ACE)
					{
						isBlackJack=true;
					}
				}
			}
		}
		return isBlackJack;
	}
	
	public boolean isFinal()
	{
		return handIsFinal;
	}
	
	public void setHandIsFinal(boolean isfinal)
	{
		handIsFinal = isfinal;
	}
	
	public boolean isHandOver()
	{
		boolean isOver=false;
		if(getHandValue() > 21)
		{
			isOver=true;
		}
		return isOver;
	}
	
	
	//SPLIT FUNCTIONALITY IS NOT FIXED YET.
	//canSplit determines if the hand has two cards of the same values and only two cards.
	// It then returns a true or false depending on the check.
	public boolean canSplit()
	{
		if(currentCards.size()  == 2)
		{
			Card c1 = currentCards.get(0);
			Card c2 = currentCards.get(1);
			//if(c1.getCountValue() == c2.getCountValue())
			if(c1.equals(c2))
			{
				canSplit = true;
			}
		}
		return canSplit;
	}
	
	//Split returns a new hand from the current hand, 
	//This will take the second card in the initial hand and return a new hand 
	//which the Participant will then store in their Hand List. 
	public Hand split()
	{
		Hand temp = new Hand();
		System.out.println("Inside Split Method in Hand.java");
		secondHandCards.add(currentCards.get(1));
		for(Card c : secondHandCards)
		{
			System.out.println(c.getPngName());
		}
		currentCards.remove(1);
		for(Card c : currentCards)
		{
			System.out.println(c.getPngName());
		}
		temp.addCard(secondHandCards.get(0));
		return temp;
	}
	
}