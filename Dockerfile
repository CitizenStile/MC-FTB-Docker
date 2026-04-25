# syntax=docker/dockerfile:1

ARG PACK_NAME="FTB Skies 2"
ARG PACK_VERSION="1.14.3"

ARG FTB_ID="129"
ARG FTB_VER="100250"

FROM eclipse-temurin:21-jdk

# Re-declare ARGS so they are available after FROM

ARG PACK_NAME
ARG PACK_VERSION
ARG FTB_ID
ARG FTB_VER

LABEL version="${PACK_VERSION}"
LABEL homepage.group=Minecraft
LABEL homepage.name="${PACK_NAME}"
LABEL homepage.icon="https://cdn.feed-the-beast.com/blob/49/4951517d1bd2376e48d280427f95fd313c7aa778bddff582296651cfae7d7a9a.png"
LABEL homepage.widget.type=minecraft
# LABEL homepage.widget.url=udp://FTB-StoneBlock-4:25565


RUN apt-get update && apt-get install -y curl && \
 adduser --uid 99 --gid 100 --home /data --disabled-password minecraft

COPY launch.sh /launch.sh
RUN chmod +x /launch.sh

USER minecraft

VOLUME /data
WORKDIR /data

EXPOSE 25565/tcp

ENV MOTD="${PACK_NAME} v${PACK_VERSION} Server Powered by Docker"
ENV LEVEL=world
ENV JVM_OPTS="-Xms6144m -Xmx8192m"
# Pass the FTB ID and version into the launch so that we only set it in one file.
ENV FTB_ID=${FTB_ID}
ENV FTB_VER=${FTB_VER}

CMD ["/launch.sh"]
