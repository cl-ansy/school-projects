package com.ood.blackjack.User;

import java.util.ArrayList;


import com.ood.blackjack.Rules.*;

public class Participant {
	private String name = "Participant";
	private int money=0;
	private int score = 0;			//To be replaced with Score Object for database manipulation
	private int bid_amount;
	private boolean turnIsDone=false;
	private boolean isWinner = false;
	
	//variables for hands and handling a split if need be.
	private ArrayList<Hand> handList;
	Hand hand;
	Hand splithand;
	
	
//	public Participant(String name, int money_amount)
//	{
//		handList = new ArrayList<Hand>();
//		hands = new Hand[2]; 
//		hand = new Hand();
//		splithand=new Hand();
//		handList.add(hand);
//		hands[0] = hand;
//		hands[1] = splithand;
//		this.name = name;
//		money=money_amount;
//		bid_amount = 50;
//	}
	
//	public Participant(String name)
//	{
//		handList = new ArrayList<Hand>();
//		hand = new Hand();
//		handList.add(hand);
//		this.name = name;
//		bid_amount = 50;
//	}
	
	public Participant()
	{
		handList = new ArrayList<Hand>();
		hand = new Hand();
		handList.add(hand);
		splithand = new Hand();
		bid_amount = 50;
	}
	
	public void addMoney(int money)
	{
		this.money += money;
	}
	public void subtractMoney(int money)
	{
		this.money -= money;
	}
	public int getMoney()
	{
		return money;
	}
	
	
	//NOT SURE IF NEED THESE,ONLY WORK FOR ONE SPLIT HAND, WHAT IF WE SPLIT AGAIN?
	public void setSplitHand(Hand h)
	{
		splithand = h;
	}
	
	public Hand getSplitHand()
	{
		return splithand;
	}
	//-----------------------------------------------------------------------------
	
	
	public void printHands()
	{
		System.out.println("PrintingHands");
		for(Hand h : handList)
		{
			System.out.println("Handlist size: " + handList.size());
			System.out.println("Printing Hand");
			h.printCards();
			System.out.println("");
		}
	}
	
	
	
	//-----------------------------------------------------
	
	
	
	
	public boolean allhandsFinal()
	{
		int finalCount=0;
		boolean isFinal=false;
		for(Hand h : getHandList())
		{
			if(h.isFinal()) finalCount++;
		}
		if(finalCount == getHandList().size()) isFinal=true;
		
		return isFinal;
	}
	
	
	
	//Returns an ArrayList of Hands including original Hand, and the newly split hand. So we can deal to both hands.
//	public ArrayList<Hand> getHands()
//	{
//		ArrayList<Hand> hands = new ArrayList<Hand>();
//		hands.add(hand);
//	if(splithand != null)
//		hands.add(splithand);
//	return hands;
//	}
	
	
	//ISWINNER SETTERS AND GETTERS
	public boolean isWinner()
	{
		return isWinner;
	}
	
	public void setAsWinner()
	{
		isWinner = true;
	}
	
	public void resetWinner()
	{
		isWinner = false;
	}
	
	//TURN SETTERS AND GETTERS
	public void setTurnDone()
	{
		turnIsDone = true;
	}
	
	public void setTurnStart()
	{
		turnIsDone = false;
	}
	
	public boolean IsTurnDone()
	{
		return turnIsDone;
	}
	//---------------------------------
	
	
	//BID AMOUNT SETTERS AND GETTERS
	public void setBidAmount(int amount)
	{
		bid_amount = amount;
	}
	
	public int getBidAmount()
	{
		return bid_amount;
	}
	//----------------------------------
	
	
	//SCORE GETTER AND SETTERS
	public void addScore(int score)
	{
		this.score += score;
	}
	
	public void subtractScore(int score)
	{
		this.score -= score;
	}
	//----------------------------------
	
	//HAND GETTER, USE THESE ONLY IF WE HAVE NOT SPLIT THE HAND.
	public Hand getInitialHand()
	{
		return hand;
	}
	
	public void setInitialHand(Hand h)
	{
		hand = h;
	}
	//CODE FOR HANDLIST MANIPULATION FOR HANDLING SPLIT HAND,THIS CODE CAN HANDLE ANY NUMBER OF HAND SPLITS
	public ArrayList<Hand> getHandList()
	{
		return handList;
	}
	
	public void addHand(Hand h)
	{
		handList.add(h);
	}
	
	public void removeHand(Hand h)
	{
		handList.remove(h);
	}
	
	public Hand gethandFromList(int index)
	{
		return handList.get(index);
	}
	//--------------------------------------------------------
	
	//NAME GETTERS AND SETTERS
	public void setName(String name)
	{
		this.name = name;
	}

	public String getName()
	{
		return name;
	}
	//-----------------------------------
	
	
}
