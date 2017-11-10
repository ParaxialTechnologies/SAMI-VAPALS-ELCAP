## VA-PALS Tests

This is a sub-module of the VA-PALS project that aims to test all functionality. Mosts tests are integration tests and 
require a running VistA instance.

To execute the test, simply run `gradle test`. Without setting additional properties, some defaults will be used.

- `privateKey`: Your local private key used to connect to the server. Default is `~/.ssh/id_rsa`.
- `user`: The username used to connect to the server. Default is the currently logged on user according to `System.getProperty("user.name")`.
- `server`: The server to use for integration tests. Default is `localhost`.
- `port`: The port of the web server. Default value is `9080`.
- `studyId`: The study ID to use a test subject. Note that the study does not need to exist. Default value is `PA0001`.

As an example:

    gradle -Dserver=avicenna.vistaexpertise.net -DstudyId=XX0001 -Duser=programmer
      