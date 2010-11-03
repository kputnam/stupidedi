set SCRIPT_DIR=%~dp0
java -Xmx512M -XX:PermSize=512M -XX:MaxPermSize=512M -jar "%SCRIPT_DIR%sbt-launch.jar" %*
