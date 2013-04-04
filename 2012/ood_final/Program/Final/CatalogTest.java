import org.junit.Test;


public class CatalogTest {
	
	@Test
	public void testBrowseBooks() throws NullPointerException {
		Book[] books1 = new Book[10];
		books1[0] = new Book("Lansing", 90912515, "Canticle");
		books1[1] = new Book("Lansing", 90912515, "Canticle");
		Catalog.browseBooks(books1);
	}

	@Test
	public void testSearchOnAuthor() throws NullPointerException {
		Book[] books2 = new Book[10];
		books2[0] = new Book("Lansing", 90912515, "Canticle");
		books2[1] = new Book("Chris", 90912515, "blar");
		Catalog.searchOnAuthor("Lansing", books2);
	}

}
