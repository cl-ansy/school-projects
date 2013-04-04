package com.ood.blackjack.Rules;

public class DealerHand extends Hand{
	//Dealer object that the hand deals with. 
		
		public DealerHand()
		{
			isDealer=true;
			isPlayer=false;
			
		}
		public void setAceAsEleven()
		{
			for(Card c : currentCards)
			{
				if(c.getValue() == Card.ACE)
				{
					if(getHandValue() < 10)
						c.setValue('f');
					break;
				}
			}
		}
	}
