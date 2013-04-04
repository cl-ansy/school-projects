package com.ood.blackjack.User;



import com.ood.blackjack.Game.*;
import com.ood.blackjack.Rules.*;
import com.ood.blackjack.*;

public class Player extends Participant{
	Score score;
	private int playerID;
	private boolean isPlayerTurn=false;
	private PlayerHand hand;

	public Player()
	{
		score = new Score();
		this.hand = new PlayerHand();
	}
	
	//USED FOR THE APPLICATION, THE USER WOULD PICK A CHOICE FROM AVAILABLE BUTTONS,
	// THIS IS THE CONSOLE VERSION OF THOSE CHOICES
//	public void chooseMove(Game g)
//	{
//		Scanner scan = new Scanner(System.in);
//		//do moves here
//		System.out.println("Current Hand Value: " + hand.getHandValue());
//		System.out.println("Choose Move: ");
//		System.out.print("Choose: 'h' for hit, 's' for stand");
//		if(getHand().canSplit())
//		{
//			System.out.println(", 'split' for split the hand");
//		}
//		String move = scan.next();
//		if(move.matches("h"))
//		{
//			PlayerMoves.hit(this, g);
//		}
//		else if(move.matches("s"))
//		{
//			PlayerMoves.stand(this);
//		}
//		else if(move.matches("split"))
//		{
//			PlayerMoves.split(this);
//		}
//	}
	
	public PlayerHand getHand()
	{
		return this.hand;
	}
	
	public void setHand(PlayerHand h)
	{
		this.hand = h;
	}
	
	public boolean isPlayerTurn()
	{
		return isPlayerTurn;
	}
	
	public void setNotPlayerTurn()
	{
		isPlayerTurn = false;
	}
	
	public void setPlayerTurn()
	{
		isPlayerTurn = true;
	}
	
	public void setId(int pid) {
		playerID=pid;
	}
	
	public int getId()
	{
		return playerID;
	}
}
