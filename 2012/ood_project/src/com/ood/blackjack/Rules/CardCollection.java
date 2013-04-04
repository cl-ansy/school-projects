package com.ood.blackjack.Rules;

import java.io.Serializable;
import java.util.Collection;
import java.util.Stack;

public abstract class CardCollection implements Serializable{
        private static final long serialVersionUID = 1L;
        
        protected Stack<Card> cards;
        protected char[] suits = {Card.CLUBS,Card.SPADES,Card.HEARTS,Card.DIAMOND};
        protected char[] values = {Card.ACE,'2','3','4','5','6','7','8','9',Card.TEN,
                        Card.JACK,Card.QUEEN,Card.KING};

        public Collection<Card> getAllCards() {
                return cards;
        }

        public int getRemainingCardsNo() {
                return cards.size();
        }
        
        /**
         * @return The next card from the Collection and removes it
         */
        public Card popTopCard() {
                Card retVal = cards.pop();
                return retVal;
        }
        
        public final Card peekTopCard(){
                return cards.peek();
        }
        
        public int count() {
                return cards.size();
        }
}