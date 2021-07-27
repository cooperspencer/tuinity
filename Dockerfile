FROM debian:buster-slim AS builder
WORKDIR /opt/minecraft
RUN apt-get update; apt-get install --yes wget
RUN wget https://ci.codemc.io/job/Spottedleaf/job/Tuinity-1.17/lastSuccessfulBuild/artifact/tuinity-paperclip.jar

FROM adoptopenjdk/openjdk16:latest AS runtime

# Working directory
WORKDIR /data

# Obtain runable jar from build stage
COPY --from=builder /opt/minecraft/tuinity-paperclip.jar /opt/minecraft/tuinity-paperclip.jar

# Volumes for the external data
VOLUME "/data"

# Expose minecraft port
EXPOSE 25565/tcp
EXPOSE 25565/udp

# Set memory size
ARG memory_size=3G
ENV MEMORYSIZE=$memory_size

# Set Java Flags
ARG java_flags="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=mcflags.emc.gs -Dcom.mojang.eula.agree=true"
ENV JAVAFLAGS=$java_flags

WORKDIR /data

# Entrypoint with java optimisations
ENTRYPOINT /opt/java/openjdk/bin/java -jar -Xms$MEMORYSIZE -Xmx$MEMORYSIZE $JAVAFLAGS /opt/minecraft/tuinity-paperclip.jar --nojline nogui