package com.paraxialtech.vapals;

import com.google.common.collect.ImmutableMap;
import com.google.common.io.ByteStreams;
import com.jcraft.jsch.JSchException;
import com.paraxialtech.vapals.vista.*;
import net.sf.expectit.Expect;
import net.sf.expectit.ExpectBuilder;
import net.sf.expectit.Result;
import net.sf.expectit.matcher.Matcher;
import net.sf.expectit.matcher.Matchers;
import org.junit.jupiter.api.DynamicTest;
import org.junit.jupiter.api.TestFactory;
import org.junit.jupiter.api.function.Executable;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.TimeUnit;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.junit.Assert.assertNotNull;
import static org.junit.jupiter.api.Assertions.fail;

/**
 * Tests {@link FilemanInterface} against a real server. Connects to the given
 * VistA server, reads/updates the given study, and compares the results against what is expected.
 */
class FilemanInterfaceCRUDTest extends AbstractVistaTest {
    private static final String STUDY_IDS = "PARAXL001";
    private static final Map<String, String> FORMS = ImmutableMap.of("SAMI BACKGROUND", "../../docs/dd/background-dd-map.csv");

    @TestFactory
    List<DynamicTest> testUpdateViaFileman() {
        final List<DynamicTest> tests = new ArrayList<>();
        for (final Entry<String, String> entry : FORMS.entrySet()) {
            tests.addAll(getTests(entry.getKey(), entry.getValue()));
        }
        return tests;
    }

    private List<DynamicTest> getTests(final String fileName, final String definitionFile) {
        final List<DynamicTest> tests = new ArrayList<>();

        try {
            // Load the data dictionary for the given form
            final FilemanDataDictionary filemanDataDictionary = new FilemanDataDictionary(fileName,
                    Paths.get(definitionFile));

            for (final String studyId : STUDY_IDS.split(",")) {
                tests.addAll(getTests(filemanDataDictionary, studyId));
            }
        } catch (final IOException e) {
            fail("Unable to read Fileman Dictionary Definition", e);
        }

        return tests;
    }

    private List<DynamicTest> getTests(final FilemanDataDictionary filemanDataDictionary, final String studyId) {
        final List<DynamicTest> tests = new ArrayList<>();
        final String forFileAndRecord = String.format("for file '%s', record '%s'", filemanDataDictionary.getFileName(), studyId);

        // Connect to a VISTA server and read in all values of the studyId
        try (final VistaServer server = new VistaServer(SERVER)) {
            assertThat(server.getCurrentState(), is(VistaServer.StateEnum.DISCONNECTED));

            server.connect(SSH_PRIVATE_KEY, SSH_USER);
            assertThat(server.getCurrentState(), is(VistaServer.StateEnum.CONNECTED));

            try (final FilemanInterface filemanInterface = server.startFileman()) {
                // 1) TODO: [D]elete the given study, if it exists.
                filemanInterface.deleteRecord(filemanDataDictionary, studyId);
                server.exitFileman();

                // 2) [C]reate the given study
                // 2.1) Read an initial set of data from file
                final Map<FilemanField, FilemanValue> initialValues = readValuesFromFile(filemanDataDictionary, studyId, 1);
                // 2.2) TODO: Write the data to VistA
                server.startFileman();
                filemanInterface.createRecord(filemanDataDictionary, studyId, initialValues);
                server.exitFileman();

                // 3) [R]ead the data from VistA and validate it
                // 3.1) Read the record from VistA
                server.startFileman();
                Map<FilemanField, FilemanValue> filemanValues = filemanInterface.readRecord(filemanDataDictionary, studyId);
                server.exitFileman();
                // 3.2) Validate each field against what we tried to write
                final int numValues = filemanValues.size();
                final String str = String.join("\n", initialValues.keySet().stream().map(String::valueOf).collect(java.util.stream.Collectors.toList()));
                tests.add(DynamicTest.dynamicTest("Initial number of fields ", () -> { assertThat("Wrong number of fields " + forFileAndRecord, numValues, is(initialValues.size())); }));
                for (final FilemanField filemanField : filemanValues.keySet()) {
                    tests.add(DynamicTest.dynamicTest("Initial value " + forFileAndRecord + ", field '" + filemanField.getFilemanName() + "'",
                                                      getFieldTest(filemanValues.get(filemanField), initialValues.get(filemanField))));
                }

                // 4) [U]pdate the study in VistA and validate it
                // 4.1) Read the set of data from file
                final Map<FilemanField, FilemanValue> updatedValues = readValuesFromFile(filemanDataDictionary, studyId, 2);
                // 4.2) Update the data in VistA
                server.startFileman();
                filemanInterface.updateRecord(filemanDataDictionary, studyId, updatedValues);
                server.exitFileman();
                // 4.3) Read the record from VistA
                server.startFileman();
                filemanValues = filemanInterface.readRecord(filemanDataDictionary, studyId);
                // 4.4) Validate each field against what we tried to write
                final int numValues2 = filemanValues.size();
                tests.add(DynamicTest.dynamicTest("Updated number of fields ", () -> { assertThat("Wrong number of fields " + forFileAndRecord, numValues2, is(initialValues.size())); }));
                for (final FilemanField filemanField : filemanValues.keySet()) {
                    tests.add(DynamicTest.dynamicTest("Updated value " + forFileAndRecord + ", field '" + filemanField.getFilemanName() + "'",
                                                      getFieldTest(filemanValues.get(filemanField), updatedValues.get(filemanField))));
                }
            }
        } catch (final IOException e) {
            fail("Unable to start shell or invoke Fileman on VistA server", e);
        } catch (final JSchException e) {
            fail(String.format("Failed to connect to SERVER='%s' with cert='%s' and user='%s'", SERVER, SSH_PRIVATE_KEY, SSH_USER), e);
        }

        return tests;
    }

    private Executable getFieldTest(final FilemanValue filemanValue, final FilemanValue expectedValue) {
        return () -> {
            assertNotNull("Field value does not exist in resource file", expectedValue);
            assertThat("Mismatched Vista/Resource value", filemanValue, is(expectedValue));
        };
    }

    /**
     * Read from a text dump of a Fileman file.
     *
     * @param dataDictionary The file we are reading
     * @param studyId
     * @param idx
     * @return
     * @throws IOException
     */
    private Map<FilemanField, FilemanValue> readValuesFromFile(final FilemanDataDictionary dataDictionary,
                                                               final String studyId,
                                                               final int idx) throws IOException {
        final Matcher<Result> selectFilePrompt = Matchers.contains("Select " + dataDictionary.getFileName());

        final String inputFile = "/" + dataDictionary.getFileName().replaceAll(" ", "_") + "-" + studyId + "-" + idx + ".fman";

        try (final Expect expect = new ExpectBuilder()
                 .withOutput(ByteStreams.nullOutputStream())
                .withInputs(this.getClass().getResourceAsStream(inputFile))
                 .withEchoInput(System.err)
                 .withExceptionOnFailure()
                 .withTimeout(1, TimeUnit.SECONDS)
                 .build()) {

            return FilemanInterface.readRecord(expect, selectFilePrompt, dataDictionary);
        } catch (FileNotFoundException e) {
            fail("Unable to read from file: " + inputFile, e);
            throw e;
        }
    }
}
