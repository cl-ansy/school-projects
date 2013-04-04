package com.ood.blackjack.Rules;

import java.util.*;

public class Card {
	
	// Suits
    public static final char HEARTS = 'h';
    public static final char SPADES = 's';
    public static final char CLUBS = 'c';
    public static final char DIAMOND = 'd';
    // Tens
    protected static final char JACK = 'j';
    protected static final char QUEEN = 'q';
    protected static final char KING = 'k';
    protected static final char TEN = 't';
    // Others
    public static final char BLACK_SUIT = 'b';
    public static final char RED_SUIT = 'r';
    public static final char ACE = '1';
    public static final char ACE_AS_ELEVEN = 'f';
    
    private char suit;
    private char value;
    private boolean isVisible;
    private boolean isSelected;

    public boolean isVisible() {
            return isVisible;
    }

    public void setVisible(boolean isVisible) {
            this.isVisible = isVisible;
    }
    
    protected boolean isSelected(){
            return isSelected;
    }
    
    public void setSelected(boolean status){
            this.isSelected = status;
    }
    
    public void setValue(char value) {
            this.value = value;
    }
    
    public char getValue() {
            return value;
    }
    
    public void setSuit(char suit) {
            this.suit = suit;
    }
    
    public char getSuit() {
            return suit;
    }

    public String getPngName() {
            return new String(new char[]{suit,'_',value});
    }

    public Card(char suit, char value) {
            super();
            this.suit = suit;
            this.value = value;
            this.isSelected = false;
    }
 
    public int getCountValue(){
        int retVal = Character.getNumericValue(this.value);
        switch (value) {
        case TEN:
        case JACK:
        case QUEEN:
        case KING:
                retVal = 10;
                break;
        case ACE:
        case ACE_AS_ELEVEN:
                retVal = 11;
                break;
        default:
                break;
        }

        return retVal;
}

/**
 * @return an integer value of the card.
 */
public Integer getIntegerValue(){
        Integer retVal = Character.getNumericValue(this.value);
        switch (value) {
        case TEN:
                retVal = 10;
                break;
        case JACK:
                retVal = 10;
                break;
        case QUEEN:
                retVal = 10;
                break;
        case KING:
                retVal = 10;
                break;
        case ACE_AS_ELEVEN:
                retVal = 11;
                break;
        default:
                break;
        }

        return retVal;
}

@Override
public String toString() {
        return new String(new char[]{getSuit(),getValue()});
}

public int compareTo(Card other) {
                return (other==null? -1 : (other.getIntegerValue()==null? 0 : other.getIntegerValue()) ) - (this.getIntegerValue()==null? 0: this.getIntegerValue());
}

@Override
public boolean equals(Object obj){
        if( (this instanceof Card && this != null) && (obj instanceof Card && obj != null )){
                boolean hasTheSameSuit = this.getSuit() == ((Card) obj).getSuit()? true : false;
                boolean hasTheSameValue = this.getIntegerValue() == ((Card) obj).getIntegerValue()? true : false;
                
                if(hasTheSameSuit && hasTheSameValue){
                        return true;
                }
        }
        return false;
}
}
