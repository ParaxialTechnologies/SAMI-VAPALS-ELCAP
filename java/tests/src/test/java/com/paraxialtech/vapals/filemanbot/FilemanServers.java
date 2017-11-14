package com.paraxialtech.vapals.filemanbot;

import java.io.IOException;

import net.sf.expectit.matcher.Matchers;

/**
 * Factory class
 *
 * @author Keith Powers
 */
public class FilemanServers {
    public static FilemanServer getOsehraDockerServer(final String url) {
        return
            new FilemanServer("avicenna.vistaexpertise.net") {
                @Override
                public FilemanServer startFileman() throws IOException {
                    validateState(StateEnum.IN_SHELL, "start fileman");

                    expect.sendLine("osehra");
                    expect.expect(Matchers.contains(shellPrompt));

                    expect.sendLine("mumps -dir");
                    expect.expect(Matchers.contains(">"));

                    expect.sendLine("SET DUZ=1");
                    expect.expect(Matchers.contains(">"));

                    expect.sendLine("DO Q^DI");

                    currentState = StateEnum.IN_FILEMAN;
                    return this;
                }

                @Override
                public FilemanServer exitFileman() throws IOException {
                    validateState(StateEnum.IN_FILEMAN, "exit fileman");

                    expect.sendLine("^");
                    expect.expect(Matchers.contains(">"));

                    expect.sendLine("HALT");
                    expect.expect(Matchers.contains(shellPrompt));

                    expect.sendLine("exit");
                    expect.expect(Matchers.contains(shellPrompt));

                    currentState = StateEnum.IN_SHELL;
                    return this;
                }
            };
    }
}
