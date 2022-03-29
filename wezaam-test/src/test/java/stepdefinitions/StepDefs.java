package stepdefinitions;

import utils.TestVariable;
import cucumber.api.java.en.Given;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.junit.Assert;

import java.time.Instant;


public class StepDefs {

    private static final String BASE_URL = "http://localhost:7070/";

    private static Response response;
    private static Integer withdrawalId_1;
    private static Integer withdrawalId_2;
    private static Integer withdrawalId_3;


    /**
     * Saves the time in seconds from the epoch of 1970-01-01T00:00:00Z to current moment into the variable ##currentDate##
     * Saves the current time into the variable ##formattedCurrentDate## in format yyyy-MM-ddTHH:mm:ssZ
     */
    @Given("^save the current time")
    public void saveCurrentTime() {

        long currentTime = Instant.now().getEpochSecond();
        TestVariable.saveVariable("##currentDate##", String.valueOf(currentTime));

        Instant formattedCurrentDate = Instant.ofEpochSecond(currentTime);
        TestVariable.saveVariable("##formattedCurrentDate##", String.valueOf(formattedCurrentDate));
    }

    /**
     * Saves the time in seconds from the epoch of 1970-01-01T00:00:00Z to current moment +10 seconds into the variable ##currentDate##
     * Saves the current time +10 seconds into the variable ##formattedCurrentDate## in format yyyy-MM-ddTHH:mm:ssZ
     *
     * Step for testing service's behaviour with future dates
     */
    @Given("^save the future time")
    public void saveFutureTime() {

        long futureTime = Instant.now().getEpochSecond()+10;
        TestVariable.saveVariable("##currentDate+10sec##", String.valueOf(futureTime));

        Instant formattedFutureDate = Instant.ofEpochSecond(futureTime);
        TestVariable.saveVariable("##formattedCurrentDate+10sec##", String.valueOf(formattedFutureDate));
    }

    @Given("^(?:.*) is doing a GET request by path \'(.*)\'$")
    public void userSendsGetRequest(String path) {

        RestAssured.baseURI = BASE_URL;
        RequestSpecification request = RestAssured.given();
        response = request.get(path);
    }

    @Given("^(?:.*) is doing a POST request by path \'(.*)\' with parameters:$")
    public void userSendsPostRequest(String path, String requestBody) {

        String replacedRequestBody = TestVariable.replaceAllVariables(requestBody);
        RestAssured.baseURI = BASE_URL;
        RequestSpecification request = RestAssured.given();
        request.header("Content-Type", "application/json");
        request.body(replacedRequestBody);

        response = request.post(path);
    }

    @Given("^(?:.*) receives the response with the code \'(.*)\'$")
    public void responseCodeShouldBe(String expectedCode) {

        Assert.assertEquals(Integer.parseInt(expectedCode), response.getStatusCode());
    }

    @Given("^the response message contains:")
    public void ResponseMessageMatchesExpected(String expectedMessage) {

        String expectedMessageReplaced = TestVariable.replaceAllVariables(expectedMessage);
        String expectedMessageWithNoGaps = expectedMessageReplaced.replace(" ", "").replace("\r\n", "");
        String actualMessageWithNoGaps = response.getBody().asString().replace(" ", "");

        Assert.assertTrue(actualMessageWithNoGaps.contains(expectedMessageWithNoGaps));
    }

    @Given("^save ID № (.*) from the response message into the variable '(.*)'$")
    public void saveIdFromResponseMessageIntoVar(int idNumber, String varName) {

        switch (idNumber) {
            case 1:
                withdrawalId_1 = Integer.valueOf(response.jsonPath().get("[0].id").toString().replaceAll("[^0-9]", ""));
                TestVariable.saveVariable(varName, String.valueOf(withdrawalId_1));
                break;
            case 2:
                withdrawalId_2 = Integer.valueOf(response.jsonPath().get("[1].id").toString().replaceAll("[^0-9]", ""));
                TestVariable.saveVariable(varName, String.valueOf(withdrawalId_2));
                break;
            case 3:
                withdrawalId_3 = Integer.valueOf(response.jsonPath().get("[2].id").toString().replaceAll("[^0-9]", ""));
                TestVariable.saveVariable(varName, String.valueOf(withdrawalId_3));
                break;
        }
    }

    @Given("^the record with the status '(.*)' and ID '(.*)' is created in DB$")
    public void RecordWithStatusIsCreatedInDB(String status, String id) {

        String replacedId = TestVariable.replaceAllVariables(id);
        String path = "/v1/withdrawals/" + replacedId;

        RestAssured.baseURI = BASE_URL;
        RequestSpecification request = RestAssured.given();
        Response response = request.get(path);
        Assert.assertEquals("200", String.valueOf(response.getStatusCode()));
        Assert.assertTrue(response.getBody().asString().contains(status));

    }

    @Given("^wait for (\\d+) ms$")
    public void waitFor(int millis) throws InterruptedException {
        Thread.sleep(millis);
    }


}
