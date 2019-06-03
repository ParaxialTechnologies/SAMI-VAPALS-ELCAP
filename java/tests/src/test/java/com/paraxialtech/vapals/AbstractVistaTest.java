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
