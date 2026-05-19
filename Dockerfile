FROM eclipse-temurin:17:eclipse/ubuntu_jreWORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]