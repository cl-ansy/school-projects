import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;


@RunWith(Suite.class)
@SuiteClasses({ BookTest.class, CatalogTest.class, MainTest.class,
		PriceScheduleTest.class, PublisherTest.class, ReviewTest.class,
		SearchResultsTest.class, StockTest.class })
public class AllTests {

}
