package com.paraxialtech.vapals;

import static org.apache.commons.lang3.ObjectUtils.defaultIfNull;

public class AbstractVistaTest {
    // Note, if you add any other properties, be sure to add the property name to the list in build.gradle so that Gradle knows to pass the value along.
    protected static final String SSH_PRIVATE_KEY = defaultIfNull(System.getProperty("privateKey"), "~/.ssh/id_rsa");
    protected static final String SSH_USER = defaultIfNull(System.getProperty("user"), System.getProperty("user.name"));
    protected static final String SERVER = defaultIfNull(System.getProperty("server"), "localhost");
    protected static final String PORT = defaultIfNull(System.getProperty("port"), "9080");
    protected static final String STUDY_IDS = defaultIfNull(System.getProperty("studyIds"), "PA0001"); //"PARAXL001" //TODO: should maybe not be a part of configuration, just use hard-coded values.
}
