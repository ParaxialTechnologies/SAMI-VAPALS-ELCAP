/*
 * Copyright (c) 2019 Early Diagnosis and Treatment Research Foundation, Vista Expertise Network (VEN), and Paraxial
 *
 * The original management system was created and donated by Early Diagnosis and Treatment Research Foundation within the
 * International Early Lung Cancer Action Program (I-ELCAP), an international program of lung cancer screening.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at: http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 */

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

    public FirstOfMultiMatcher(final Matcher<?>... matchers) {
        this.matchers = matchers;
    }

    @Override
    public MultiResult matches(final String input, final boolean isEof) {
        final List<Result> results = new ArrayList<>();
        Result successResult = null;
        for (final Matcher<?> matcher : matchers) {
            final Result result = matcher.matches(input, isEof);
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
        final StringBuilder matchersString = matchersToString(matchers);
        return String.format("firstOf(%s)", matchersString);
    }

    private static StringBuilder matchersToString(final Matcher<?>... matchers) {
        final StringBuilder matchersString = new StringBuilder();
        for (final Matcher<?> matcher : matchers) {
            if (matchersString.length() > 0) {
                matchersString.append(',');
            }
            matchersString.append(matcher);
        }
        return matchersString;
    }
}
