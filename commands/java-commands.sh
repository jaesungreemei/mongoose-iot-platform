# java version 두 개 깔렸을 경우 버전 변경
sudo update-alternatives --config java

# Step 1: Create Maven Project
mvn archetype:generate -DgroupId=com.mongooseai -DartifactId=test-mssql-app -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
mvn archetype:generate "-DgroupId=com.mongooseai" "-DartifactId=test-java-app" "-DarchetypeArtifactId=maven-archetype-quickstart" "-DinteractiveMode=false"
mvn archetype:generate "-DgroupId=com.mongooseai" "-DartifactId=test-iot-data" "-DarchetypeArtifactId=maven-archetype-quickstart" "-DinteractiveMode=false"

# Create package
mvn clean install
mvn clean compile assembly:single
java -jar <.jar file>
java -jar test-iot-data-1.0-jar-with-dependencies.jar

# Configure name of compiled .jar file by editing pom.xml
'''
  <build>
    <finalName>test-mssql-app</finalName>
  </build>
'''

# Execute application
'''
  <build>
      <plugins>
          <plugin>
              <groupId>org.codehaus.mojo</groupId>
              <artifactId>exec-maven-plugin</artifactId>
              <version>3.0.0</version>
              <executions>
                  <execution>
                      <goals>
                          <goal>java</goal>
                      </goals>
                  </execution>
              </executions>
              <configuration>
                  <mainClass>com.mongooseai.App</mainClass>
              </configuration>
          </plugin>
      </plugins>
  </build>
'''
mvn clean install
mvn exec:java

# Re-compile and execute application in one command
'''
        <!-- Compile and Execute -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.8.1</version> <!-- or the version you prefer -->
            <configuration>
                <source>1.8</source> <!-- or your Java version -->
                <target>1.8</target> <!-- or your Java version -->
            </configuration>
        </plugin>
'''
mvn compile exec:java