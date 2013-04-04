public class Catalog {
	
	static void browseBooks(Book[] booksIn){
		for(int i=0; i<1; i++){
			System.out.println(""+Book.retrieveDetails(booksIn[i]));
		}
	}
	static void searchOnAuthor(String authorIn, Book[] booksIn){
		for (int i=0; i<1; i++){
			if(booksIn[i].author==authorIn){
				System.out.println(""+booksIn[i].title);
			}
		}
	}
}
