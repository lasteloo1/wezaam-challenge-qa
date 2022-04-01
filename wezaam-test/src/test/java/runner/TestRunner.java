package runner;

import cucumber.api.CucumberOptions;
import cucumber.api.SnippetType;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        features = "src/test/resources/features",
        glue = "stepdefinitions",
        tags = "@all",
        snippets = SnippetType.UNDERSCORE,
        plugin = {
                "json:target/cucumber4.json",
                "pretty",
                "html:target/cucumber-reports/cucumber-pretty.html"
        }
)
public class TestRunner {
}