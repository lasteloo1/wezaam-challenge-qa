#### Autotests project description:
- BDD framework: `Java`  + `Cucumber` + `RestAssured`
- JDK version: `Bellsoft Liberica JDK (13)` (https://bell-sw.com/pages/downloads/)
- Build automation tool: `Maven` (https://maven.apache.org/download.cgi)
- Development environment: `IntelliJ IDEA` (https://www.jetbrains.com/idea/download/other.html)
- Reporting tool: `Cucumber Pretty plugin`
---
#### How to prepare the environment for the test execution:
- Install `JDK` and `IntelliJ IDEA`
- Install Apache Maven `Maven` (https://maven.apache.org/install.html)
- Install `Cucumber for Java` and `Gherkin` plugins in the `IntelliJ IDEA` (File -> Settings -> Plugins)
- Add `wezaam-test` as Maven project in IDE
---
#### How to execute autotests:
- Launch the Withdrawal service
- Run the command `mvn clean install`
- Report will be generated to `target/cucumber-reports/cucumber-pretty.html/index.html`
- You can also run the autotests from `TestRunner.java`
- Feature-file with test scenarios is in the file `src/test/resources/features/Withdrawal.feature`
---
If you have any questions or comments - my e-mail is `ooletsal@gmail.com` (Aleksandra)