package com.paraxialtech.vapals.vista;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import net.sf.expectit.Expect;
import net.sf.expectit.ExpectBuilder;
import net.sf.expectit.matcher.Matchers;

import java.io.Closeable;
import java.io.IOException;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

import static com.google.common.base.Preconditions.checkState;

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
public class VistaServer implements Closeable {
    private final String serverName;
    private StateEnum currentState = StateEnum.DISCONNECTED;

    private Session session = null;
    private Channel channel = null;
    private Expect shellExpect = null;

    private static final String MUMPS_PROMPT = "VAPALS>";
    private static final String SHELL_PROMPT = "~$";

    /**
     * Constructor. Takes the URL of the server to connect to.
     *
     * @param serverName eg: "vhost.example.org"
     */
    public VistaServer(final String serverName) {
        this.serverName = serverName;
    }

    public StateEnum getCurrentState() {
        return currentState;
    }

    /**
     * Cleanly disconnect from the server regardless of current state.
     *
     * @throws IOException if unable to close
     */
    @Override
    public void close() throws IOException {

        if (currentState == StateEnum.FILEMAN) {
            exitFileman();
        }
        if (currentState == StateEnum.MUMPS) {
            exitMumps();
        }
        if (currentState == StateEnum.CONNECTED) {
            disconnect();
        }

    }

    /**
     * Connect to the server with the indicated private key &amp; user name.
     *
     * @param privateKeyLocation The (relative) path to the desired private key.
     * @param sshUserName        The user name to use to log into the remote hose.
     * @throws JSchException if unable to connect
     */
    public void connect(final String privateKeyLocation, final String sshUserName) throws JSchException { //TODO wrap this exception JSch should be contained within this class only
        checkState(this.currentState == StateEnum.DISCONNECTED, "Current state not DISCONNECTED, is " + this.currentState);

        final JSch jSch = new JSch();
        jSch.addIdentity(privateKeyLocation);
        session = jSch.getSession(sshUserName, serverName);
        final Properties config = new Properties();
        config.put("StrictHostKeyChecking", "no");
        session.setConfig(config);
        session.connect();
        currentState = StateEnum.CONNECTED;
    }

    /**
     * Disconnect from the remote host.
     */
    private void disconnect() {
        checkState(this.currentState == StateEnum.CONNECTED, "Current state not CONNECTED, is " + this.currentState);

        session.disconnect();
        session = null;

        currentState = StateEnum.DISCONNECTED;
    }

    /**
     * Spawn a shellExpect on the remote host and wait for the specified text to appear
     * (as is standard from the "shellExpect" utility) which indicates that the shellExpect
     * spawned successfully.
     *
     * @return This {@linkplain VistaServer} object.
     * @throws JSchException if unable to connect to the servers' shell
     * @throws IOException if shell expectations fail
     */
    public Expect startMumps() throws JSchException, IOException {
        checkState(this.currentState == StateEnum.CONNECTED, "Current state not CONNECTED, is " + this.currentState);

        channel = session.openChannel("shell");
        channel.connect();

        shellExpect = new ExpectBuilder()
                .withOutput(channel.getOutputStream())
                .withInputs(channel.getInputStream(), channel.getExtInputStream())
                //.withEchoOutput(System.out)
                .withEchoInput(System.err)
                //.withInputFilters(removeColors(), removeNonPrintable())
                .withExceptionOnFailure()
                .withTimeout(10, TimeUnit.SECONDS)
                .build();

        //basic shell
        shellExpect.expect(Matchers.contains(SHELL_PROMPT));

        //enter the world of MUMPS!
        shellExpect.sendLine("osehra");

        shellExpect.sendLine("mumps -dir");
        shellExpect.expect(Matchers.contains(MUMPS_PROMPT));

        currentState = StateEnum.MUMPS;

        return shellExpect;
    }

    /**
     * Exit from the remote shellExpect.
     *
     * @throws IOException
     */
    private void exitMumps() throws IOException {
        checkState(this.currentState == StateEnum.MUMPS, "Current state not MUMPS, is " + this.currentState);

        shellExpect.sendLine("HALT");
        shellExpect.expect(Matchers.eof());

        shellExpect.close();
        shellExpect = null;

        channel.disconnect();
        channel = null;

        currentState = StateEnum.CONNECTED;

    }

    /**
     * Start Fileman in the remote shellExpect.
     *
     * @return This {@linkplain VistaServer} object.
     * @throws IOException if shell expectations fail
     */
    public FilemanInterface startFileman() throws IOException {
        checkState(this.currentState == StateEnum.MUMPS, "Current state not MUMPS, is " + this.currentState);

        shellExpect.sendLine("SET DUZ=1");

        shellExpect.sendLine("DO Q^DI");
        shellExpect.expect(Matchers.contains("FileMan"));

        currentState = StateEnum.FILEMAN;

        return new FilemanInterface(shellExpect, this);
    }


    /**
     * Exit from Fileman.
     *
     * @throws IOException if shell expectations fail
     */
    void exitFileman() throws IOException {
        checkState(this.currentState == StateEnum.FILEMAN, "Current state not FILEMAN, is " + this.currentState);

        shellExpect.sendLine(); //exit from Fileman itself
        shellExpect.expect(Matchers.contains(MUMPS_PROMPT));
        currentState = StateEnum.MUMPS;
    }

    public enum StateEnum {
        DISCONNECTED,
        CONNECTED,
        MUMPS,
        FILEMAN
    }
}
