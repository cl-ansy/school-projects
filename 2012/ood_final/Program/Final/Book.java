
public class Book  {
	String author;
	int discountPct;
	int ISBN;
	int price;
	String publishedDate;
	String publisher;
	int quantityOnHand;
	int replenishThreshold;
	String title;
	
	static String retrieveDetails(Book bookIn){
		return ""+bookIn.title+bookIn.author+bookIn.author+bookIn.price+bookIn.discountPct+bookIn.publisher+
				bookIn.publishedDate+bookIn.quantityOnHand+bookIn.replenishThreshold;
	}
	
	public Book(){}
	public Book(String authorIn){
		this.author=authorIn;
	}
	public Book(String authorIn, int ISBNIn, String titleIn){
		this.author=authorIn;
		this.ISBN=ISBNIn;
		this.title=titleIn;
	}
	public Book(String authorIn, int ISBNIn, String titleIn, Publisher publisherIn, Stock stockIn, PriceSchedule priceIn){
		this.author=authorIn;
		this.ISBN=ISBNIn;
		this.title=titleIn;
		this.publisher=publisherIn.pubName;
		this.publishedDate=publisherIn.pubDate;
		this.quantityOnHand=stockIn.quantityOnHand;
		this.replenishThreshold=stockIn.replenishThreshold;
		this.price=priceIn.price;
		this.discountPct=priceIn.discountPct;
	}

}
