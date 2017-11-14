package com.paraxialtech.vapals.filemanbot;

import java.io.IOException;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import net.sf.expectit.Expect;
import net.sf.expectit.ExpectBuilder;
import net.sf.expectit.matcher.Matchers;

/**
 * This class provides way to programmatically connect to a remote server
 * running VistA, and to interact with Fileman on the server as if the program
 * was very fast typist sitting at a remote terminal.
 * <p/>
 * The methods in the class expose a fluent interface for ease of use.
 * <p/>
 * Each instance of this class is intended to be used for a single remote
 * server. Create a new instance if you need to connect to two or more servers.
 * In addition, the reason that {@linkplain #startFileman} and
 * {@linkplain #exitFileman()} are abstract is because each server can have its
 * own idiosyncrasies when it comes to logging in and starting/stopping Fileman.
 * <p/>
 * Not thread-safe.
 *
 * @author Keith Powers
 */
public abstract class FilemanServer {
    private final String serverUrl;
    protected StateEnum currentState;

    private Session session = null;
    private Channel channel = null;
    protected Expect expect = null;
    protected String shellPrompt = null;

    /**
     * Constructor. Takes the URL of the server to connect to.
     *
     * @param serverUrl
     *            eg: "vhost.example.org"
     */
    public FilemanServer(final String serverUrl) {
        this.serverUrl = serverUrl;
        currentState = StateEnum.READY;
    }

    /**
     * Omnibus method to connect, spawn a shell, start fileman, and return a ready
     * Expect object.
     *
     * @param privateKeyLocation
     * @param sshUserName
     * @param promptToExpect
     * @return
     * @throws IOException
     * @throws JSchException
     */
    public Expect getFilemanExpectObject(final String privateKeyLocation,
                                         final String sshUserName,
                                         final String promptToExpect) throws IOException, JSchException {
        connect(privateKeyLocation, sshUserName);
        spawnShell(promptToExpect);
        startFileman();
        return expect;
    }

    /**
     * Omnibus method to connect, spawn a shell, start fileman, and return a ready
     * Expect object.
     *
     * This variation allows echoing the remote server's output to eg: STDOUT/STDERR.
     *
     * @param privateKeyLocation
     * @param sshUserName
     * @param promptToExpect
     * @param echoOutput
     * @param echoInput
     * @return
     * @throws IOException
     * @throws JSchException
     */
    public Expect getFilemanExpectObject(final String privateKeyLocation,
                                         final String sshUserName,
                                         final String promptToExpect,
                                         final Appendable echoOutput,
                                         final Appendable echoInput) throws IOException, JSchException {
        connect(privateKeyLocation, sshUserName);
        spawnShell(promptToExpect, echoOutput, echoInput);
        startFileman();
        return expect;
    }

    /**
     * Omnibus method to exit out of Fileman, exit the shell, and close the
     * connection.
     *
     * @throws IOException
     */
    public void close() throws IOException {
        exitFileman();
        exitShell();
        disconnect();
    }

    /**
     * Connect to the server with the indicated private key &amp; user name.
     *
     * @param privateKeyLocation
     *            The (relative) path to the desired private key.
     * @param sshUserName
     *            The user name to use to log into the remote hose.
     * @return This {@linkplain FilemanServer} object.
     * @throws JSchException
     */
    public FilemanServer connect(final String privateKeyLocation, final String sshUserName) throws JSchException {
        validateState(StateEnum.READY, "connect");

        JSch jSch = new JSch();
        jSch.addIdentity(privateKeyLocation);
        session = jSch.getSession(sshUserName, serverUrl);
        Properties config = new Properties();
        config.put("StrictHostKeyChecking", "no");
        session.setConfig(config);

        return connect(session);
    }

    /**
     * A more generic way to connect to the remote server if, for example, your host
     * uses username/password authentication.
     *
     * @param session
     *            A JSch {@linkplain Session} object.
     * @return This {@linkplain FilemanServer} object.
     * @throws JSchException
     */
    public FilemanServer connect(final Session session) throws JSchException {
        validateState(StateEnum.READY, "connect");

        this.session = session;
        session.connect();

        currentState = StateEnum.CONNECTED;
        return this;
    }

    /**
     * Disconnect from the remote host.
     *
     * @return This {@linkplain FilemanServer} object.
     */
    public FilemanServer disconnect() {
        validateState(StateEnum.CONNECTED, "disconnect");

        session.disconnect();
        session = null;

        currentState = StateEnum.READY;
        return this;
    }

    /**
     * Spawn a shell on the remote host and wait for the specified text to appear
     * (as is standard from the "expect" utility) which indicates that the shell
     * spawned successfully.
     *
     * @param promptToExpect
     *            A string representing text that, when received from the remote
     *            host, indicates the shell spawned successfully.
     * @return This {@linkplain FilemanServer} object.
     * @throws JSchException
     * @throws IOException
     */
    public FilemanServer spawnShell(final String promptToExpect) throws JSchException, IOException {
        return spawnShell(promptToExpect, null, null);
    }

    /**
     * Spawn a shell on the remote host and wait for the specified text to appear
     * (as is standard from the "expect" utility) which indicates that the shell
     * spawned successfully.
     *
     * @param promptToExpect
     *            A string representing text that, when received from the remote
     *            host, indicates the shell spawned successfully.
     * @return This {@linkplain FilemanServer} object.
     * @throws JSchException
     * @throws IOException
     */
    public FilemanServer spawnShell(final String promptToExpect,
                                    final Appendable echoOutput,
                                    final Appendable echoInput) throws JSchException, IOException {
        validateState(StateEnum.CONNECTED, "spawn a shell");

        channel = session.openChannel("shell");
        channel.connect();

        expect = new ExpectBuilder()
              .withOutput(channel.getOutputStream())
              .withInputs(channel.getInputStream(), channel.getExtInputStream())
              .withEchoOutput(echoOutput)
              .withEchoInput(echoInput)
//              .withInputFilters(removeColors(), removeNonPrintable())
              .withExceptionOnFailure()
              .withTimeout(10, TimeUnit.SECONDS)
              .build();
        shellPrompt = promptToExpect;

        expect.expect(Matchers.contains(shellPrompt));

        currentState = StateEnum.IN_SHELL;
        return this;
    }

    /**
     * Exit from the remote shell.
     *
     * @return This {@linkplain FilemanServer} object.
     * @throws IOException
     */
    public FilemanServer exitShell() throws IOException {
        validateState(StateEnum.IN_SHELL, "exit the shell");

        expect.sendLine("exit");
        expect.expect(Matchers.eof());

        expect.close();
        expect = null;

        channel.disconnect();
        channel = null;

        currentState = StateEnum.CONNECTED;
        return this;
    }

    /**
     * Start Fileman in the remote shell.
     *
     * @return This {@linkplain FilemanServer} object.
     * @throws IOException
     */
    public abstract FilemanServer startFileman() throws IOException;

    /**
     * Exit from Fileman.
     *
     * @return This {@linkplain FilemanServer} object.
     * @throws IOException
     */
    public abstract FilemanServer exitFileman() throws IOException;

    /**
     * Verify that we are in the correct state to do the desired action, otherwise
     * throw an {@linkplain IllegalStateException}
     *
     * @param expectedState
     * @param actionDescription
     */
    protected void validateState(final StateEnum expectedState, final String actionDescription) {
        if (currentState != expectedState) {
            throw new IllegalStateException("I must be " + expectedState + " to " + actionDescription + ", but my current state is '" + currentState + "'");
        }
    }

    public enum StateEnum {
        READY,
        CONNECTED,
        IN_SHELL,
        IN_FILEMAN;
    }
}
