package com.ood.blackjack.Game;

public abstract class GameManager {

	protected Game game;
	public Game getGame() { return game; }
	public void createNewGame() { game = new Game(); }
	protected void destroyGame() { game = null; }
	
	public abstract void buildPlayers();
	public abstract void buildRules();
	public abstract void buildTable();
	public abstract void syncDatabase();
	
}
