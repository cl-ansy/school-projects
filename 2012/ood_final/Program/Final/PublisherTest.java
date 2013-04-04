import static org.junit.Assert.*;

import org.junit.Test;


public class PublisherTest {

	@Test
	public void testPublisher() {
		Publisher publisher1 = new Publisher();
	}

	@Test
	public void testPublisherStringString() {
		Publisher publisher2 = new Publisher("asdf", ";jlk");
	}

}
