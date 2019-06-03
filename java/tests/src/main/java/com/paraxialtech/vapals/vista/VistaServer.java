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
        if (currentState == StateEnum.SHELL) {
            exitShell();
        }
        if (currentState == StateEnum.CONNECTED) {
            session.disconnect();
            session = null;

            currentState = StateEnum.DISCONNECTED;
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
     *
     * @throws IOException if shell expectations fail
     */
    private void startMumps() throws IOException, JSchException {
        if (currentState != StateEnum.SHELL) {
            startShell();
        }

        checkState(this.currentState == StateEnum.SHELL, "Current state not SHELL, is " + this.currentState);

        //enter the world of MUMPS!
        shellExpect.sendLine("osehra");
        shellExpect.sendLine("mumps -dir");

        shellExpect.expect(Matchers.contains(MUMPS_PROMPT));

        currentState = StateEnum.MUMPS;
    }

    /**
     * Gets us from a connected state to a Shell prompt that utilizes an Expect utility to continue interacting with.
     *
     * @throws JSchException if unable to connect to the servers' shell
     * @throws IOException   if shell expectations fail
     */
    private Expect startShell() throws JSchException, IOException {
        checkState(this.currentState == StateEnum.CONNECTED, "Current state not CONNECTED, is " + this.currentState);

        channel = session.openChannel("shell");
        channel.connect();

        shellExpect = new ExpectBuilder()
                .withOutput(channel.getOutputStream())
                .withInputs(channel.getInputStream(), channel.getExtInputStream())
                //.withEchoOutput(System.err)
                .withEchoInput(System.out)
                //.withInputFilters(removeColors(), removeNonPrintable())
                .withExceptionOnFailure()
                .withTimeout(10, TimeUnit.SECONDS)
                .build();

        shellExpect.expect(Matchers.contains(SHELL_PROMPT));
        currentState = StateEnum.SHELL;

        return shellExpect;
    }
    /**
     * Exit from the remote shellExpect.
     *
     * @throws IOException
     */
    private void exitMumps() throws IOException {
        checkState(this.currentState == StateEnum.MUMPS, "Current state not MUMPS, is " + this.currentState);

        shellExpect.sendLine("HALT"); //exit mumps
        shellExpect.expect(Matchers.contains(SHELL_PROMPT));

        currentState = StateEnum.SHELL;
    }

    private void exitShell() throws IOException {
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
    public FilemanInterface startFileman() throws IOException, JSchException {
        if (currentState !=StateEnum.MUMPS){
            startMumps();
        }

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
    public void exitFileman() throws IOException {
        checkState(this.currentState == StateEnum.FILEMAN, "Current state not FILEMAN, is " + this.currentState);

        shellExpect.sendLine(); //exit from Fileman itself
        shellExpect.expect(Matchers.contains(MUMPS_PROMPT));
        currentState = StateEnum.MUMPS;
    }

    public enum StateEnum {
        DISCONNECTED,
        CONNECTED,
        SHELL,
        MUMPS,
        FILEMAN
    }
}
