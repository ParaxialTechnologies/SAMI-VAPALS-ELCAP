## VAPALS-ELCAP Tests

This is a sub-module of the VAPALS-ELCAP project that aims to test all functionality by running automated tests 
through the web interface and asserting expected results through a connected VistA instance. The tests contained within 
this module are NOT unit tests, rather are integration tests used to perform overall quality assurance of the system. 
Any artifacts generated or utilized by this module are not intended to be distributed with the VAPALS-ELCAP software. 

These tests utilize __Selenium__ to simulate a Web Browser interface and the __Expect__ port [ExpectIt](https://github.com/Alexey1Gavrilov/ExpectIt) to connect to a VistA instance and test command line interfaces to data. Both Selenium and ExpectIt Apache 2.0 licensed open-source projects.

To execute the test, simply run `gradle test`. Without setting additional properties, some defaults will be used.

- `privateKey`: Your local private key used to connect to the server. Default is `~/.ssh/id_rsa`.
- `user`: The username used to connect to the server. Default is the currently logged on user according to `System.getProperty("user.name")`.
- `server`: The server to use for integration tests. Default is `localhost`.
- `port`: The port of the web server. Default value is `9080`.
- `studyIds`: A comma separated list of study IDs to use as test subjects. Note that the study does not need to exist. Default value is `PA0001`.

As an example:

    gradle test -Dserver=avicenna.vistaexpertise.net -DstudyId=XX0001 -Duser=programmer
      