
public class Main {
	/*
	 * Constructors:
	 * Book(String authorIn, int ISBNIn, String titleIn)
	 * Book(String authorIn, int ISBNIn, String titleIn, Publisher publisherIn, Stock stockIn, PriceSchedule priceIn)
	 * Publisher(String pubDateIn, String pubNameIn)
	 * Stock(int quantityOnHandIn, int replenishThresholdIn)
	 * PriceSchedule(int discountPctIn, int priceIn)
	 * Review(int ratingIn, String writtenReviewIn)
	 * 
	 */
	public static void main(String[] args){
		//create a publisher
		Publisher publisher1 = new Publisher("08/06/90", "Pearson");
		//create stock
		Stock stock1 = new Stock(23, 5);
		//create price info
		PriceSchedule priceschedule1 = new PriceSchedule(5, 20);
		//create a review
		Review review1 = new Review(6, "asdf");
		//create a book
		Book[] books = new Book[10];
		books[0] = new Book("Lansing", 90912515, "Canticle", publisher1, stock1, priceschedule1);
		//get the details of the book that was created
		System.out.println(""+Book.retrieveDetails(books[0]));
		//search in books for a book with author "Lansing"
		Catalog.searchOnAuthor("Lansing", books);
	}
}
