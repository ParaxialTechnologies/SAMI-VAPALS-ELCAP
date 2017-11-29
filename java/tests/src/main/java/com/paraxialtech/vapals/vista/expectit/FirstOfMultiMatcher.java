package com.paraxialtech.vapals.vista.expectit;

import net.sf.expectit.MultiResult;
import net.sf.expectit.Result;
import net.sf.expectit.matcher.Matcher;

import java.util.ArrayList;
import java.util.List;

/**
 * For some reason, the package maintainer's version of {@link MultiMaker} is
 * package-private, so this is the basically that whole class, modified to suit
 * our needs rather than simply extended.
 * <p/>
 * Specifically, this class returns the result of the first (as defined by the
 * order in which the matchers are passed into the constructor) Matcher to have
 * a successful match.
 *
 * @author Keith Powers
 */
public class FirstOfMultiMatcher implements Matcher<MultiResult> {
    private final Matcher<?>[] matchers;

    public FirstOfMultiMatcher(final List<Matcher<Result>> matchers2) {
        this((Matcher<?>[]) matchers2.toArray());
    }

    public FirstOfMultiMatcher(Matcher<?>... matchers) {
        this.matchers = matchers;
    }

    @Override
    public MultiResult matches(String input, boolean isEof) {
        List<Result> results = new ArrayList<Result>();
        Result successResult = null;
        for (Matcher<?> matcher : matchers) {
            Result result = matcher.matches(input, isEof);
            if (successResult == null && result.isSuccessful()) {
                successResult = result;
            }
            results.add(result);
        }

        if (successResult != null) {
            return new MultiResultImpl2(successResult, results);
        }

        return new MultiResultImpl2(results.get(0), results);
    }

    @Override
    public String toString() {
        StringBuilder matchersString = matchersToString(matchers);
        return String.format("firstOf(%s)", matchersString);
    }

    static StringBuilder matchersToString(final Matcher<?> ... matchers) {
        StringBuilder matchersString = new StringBuilder();
        for (Matcher<?> matcher : matchers) {
            if (matchersString.length() > 0) {
                matchersString.append(',');
            }
            matchersString.append(String.valueOf(matcher));
        }
        return matchersString;
    }
}
