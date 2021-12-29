FROM openjdk:11 as builder
WORKDIR /app
COPY . .
RUN chmod +x gradlew
RUN ./gradlew build

FROM tomcat:9
WORKDIR webapps
copy --from=builder /app/build/libs/sampleWeb-*-SNAPSHOT.war .
RUN rm -rf ROOT && mv sampleWeb-*-SNAPSHOT.war ROOT.war