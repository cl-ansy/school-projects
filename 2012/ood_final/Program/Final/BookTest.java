import static org.junit.Assert.*;

import org.junit.Test;


public class BookTest {
	
	@Test
	public void testRetrieveDetails() {
		Book book1 = new Book();
		Book book2 = new Book();
		assertEquals(Book.retrieveDetails(book1), Book.retrieveDetails(book2));
	}

	@Test
	public void testBook() {
		Book book3 = new Book();
	}

	@Test
	public void testBookStringIntString() {
		Book book4 = new Book("asdf", 5, ";lkj");
	}

	@Test
	public void testBookStringIntStringPublisherStockPriceSchedule() {
		Book book5 = new Book("asdf", 5, ";lkj", new Publisher(), new Stock(), new PriceSchedule());
	}
	
}
