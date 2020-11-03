FROM maven:3-openjdk-11 AS base

FROM base as build

ENV VERTICLE_FILE search-fat.jar

# Set the location of the verticles

COPY src /build/src
COPY pom.xml /build/pom.xml
COPY conf /build/conf

WORKDIR /build

RUN mvn package

FROM base as deploy

ENV VERTICLE_HOME /usr/verticles
ENV SITEMAPS_HOME /usr/verticles/sitemaps

EXPOSE 8080 8081

RUN addgroup --system vertx && adduser --system --group vertx

# Copy your fat jar to the container
COPY --from=build /build/target/$VERTICLE_FILE $VERTICLE_HOME/
COPY conf/elasticsearch $VERTICLE_HOME/conf/elasticsearch
COPY conf/config.json.sample $VERTICLE_HOME/conf/config.json
COPY test $VERTICLE_HOME/test

RUN mkdir $SITEMAPS_HOME
RUN chown -R vertx:vertx $VERTICLE_HOME 
RUN chmod -R a+rwx $VERTICLE_HOME

USER vertx

# Launch the verticle
WORKDIR $VERTICLE_HOME
ENTRYPOINT ["sh", "-c"]
CMD ["exec java $JAVA_OPTS -jar $VERTICLE_FILE"]
