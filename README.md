# financialadvisory

test commit

## Run in VS Code with Tomcat

This project is still an Eclipse-style dynamic web project. It does not use Maven
or Gradle. VS Code is configured to use the existing source layout:

- Java sources: `src/main/java`
- Web root: `src/main/webapp`
- Compiled classes: `build/classes`
- Local runtime JARs: `src/main/webapp/WEB-INF/lib/*.jar`
- Context root: `aiadvisoryfinancial`
- HTTP port: read from your Tomcat `conf/server.xml`

### Requirements

- JDK 22
- Apache Tomcat 11.0.22, or a compatible Tomcat 11 install
- Oracle database available at `jdbc:oracle:thin:@//localhost:1521/freepdb1`
- `TOMCAT_HOME` environment variable pointing to the local Tomcat folder
- Optional `GEMINI_API_KEY` environment variable for AI advisory features

Example PowerShell setup:

```powershell
$env:TOMCAT_HOME = "C:\path\to\apache-tomcat-11.0.22"
$env:GEMINI_API_KEY = "your-api-key"
```

### VS Code Tasks

Open **Terminal > Run Task** and use:

- `tomcat: compile` to compile Java classes into `build/classes`
- `tomcat: deploy exploded webapp` to prepare `.vscode/tomcat-deploy/aiadvisoryfinancial`
- `tomcat: start` to compile, deploy, and start Tomcat
- `tomcat: stop` to stop Tomcat
- `tomcat: clean deploy output` to remove generated VS Code deployment files

After `tomcat: start`, open the URL printed by the task. With the current local
Tomcat configuration this is:

- `http://localhost:8081/aiadvisoryfinancial/`
- `http://localhost:8081/aiadvisoryfinancial/login.jsp`

The file `src/main/webapp/WEB-INF/lib/.jar` is intentionally excluded from the
VS Code classpath and deployment tasks because it appears to be an accidental
hidden duplicate JAR. Delete it later only after confirming it is not needed.
