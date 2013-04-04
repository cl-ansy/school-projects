package com.ood.blackjack.Rules;
import java.util.Collections;
import java.util.List;
import java.util.Stack;
import android.util.Log;

	public class Deck extends CardCollection {
	        private static final long serialVersionUID = 1L;
	        private static final String LOG_TAG = "Deck";

	        public Deck() {
	                super();
	                // Create a temporary deck
	                Stack<Card> deckTemp = new Stack<Card>();
	                // Add the 52 suit\value combinations
	                for (char suit : suits)  {
	                        for (char value : values) {
	                                deckTemp.add(new Card(suit,value));
	                                System.out.println("Suit:" + new Card(suit,value).getSuit());
	                                System.out.println("Value: "+ new Card(suit,value).getValue());
	                        }
	                }

	                
	                // Shuffle it
	                Collections.shuffle(deckTemp);
	                
	                // And lets get it on!
	                cards = deckTemp;
	        }
	        
	        public void addCards(List<Card> cardsToAdd) {
	                cards.addAll(cardsToAdd);
	        }
	        
	        public Card popTopCard() {
	                // If there are no cards, refill deck 
	                if (cards.isEmpty()) {
	                        Log.w(LOG_TAG,"Deck was empty, refilling...");
	                        for (char suit : suits)  {
		                        for (char value : values) {
		                                cards.add(new Card(suit,value));
		                        }
		                }
	                     Collections.shuffle(cards);
	                }

	                Card retVal = cards.pop();
	                return retVal;
	        }
	        
	        public void shuffle()
	        {
	        	Collections.shuffle(cards);
	        }

	}


