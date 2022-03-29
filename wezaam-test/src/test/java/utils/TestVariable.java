package utils;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class TestVariable {
    String name;
    String value;

    public static final String VARIABLE_PREFIX = "##";
    private static final Pattern VARIABLE_PREFIX_PATTERN = Pattern.compile(VARIABLE_PREFIX);

    private static final ArrayList<TestVariable> variablesList = new ArrayList<>();
    private static final HashMap<String, String> stepVariables = new HashMap<>();

    public String getName() {
        return name;
    }

    public String getValue() {
        return value;
    }

    public TestVariable(String varName, String varValue) {
        this.name = varName;
        this.value = varValue;
    }

    private static String resolveVariable(String variableName) {

        String resolvedVar = null;
        for (TestVariable var : variablesList) {
            if (var.getName().equals(variableName)) {
                resolvedVar = var.getValue();
            }
        }
        if (resolvedVar == null) {
            System.err.println(String.format("variable with name %s has not been saved", variableName));
        }
        return resolvedVar;
    }

    private static Set<String> extractVariables(String expression) {

        Set<String> variableSet = new HashSet<>();

        Matcher matcher = VARIABLE_PREFIX_PATTERN.matcher(expression);
        while (matcher.find()) {
            int beginIndex = matcher.start();
            if (matcher.find()) {
                variableSet.add(expression.substring(beginIndex, matcher.end()));
            }
        }

        return variableSet;
    }

    public static String replaceAllVariables(final String expression) {
        String result = expression;

        Set<String> extractedVars = extractVariables(expression);

        for (String var : extractedVars) {
            String value = resolveVariable(var);
            stepVariables.put(var, value);
            result = result.replace(var, value);
        }
        return result;
    }

    public static void saveVariable(String varName, String varValue) {
        variablesList.add(new TestVariable(varName, varValue));

    }
}