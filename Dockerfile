FROM registry.gitlab.com/ultimaker/cura/cura-build-environment:centos7 as build

ARG VERSION=4.3.0
ADD --chown=ultimaker https://github.com/Ultimaker/CuraEngine/archive/${VERSION}.tar.gz ./cura-engine.tar.gz

USER ultimaker
RUN tar -xzf cura-engine.tar.gz
RUN mv CuraEngine-${VERSION} CuraEngine && cd CuraEngine && ./docker/build.sh

FROM alpine as defs
RUN apk add git
WORKDIR /src
RUN git clone --depth 1 https://github.com/Ultimaker/Cura.git

FROM centos:7

RUN yum -y -q install libgomp
COPY --from=build /home/ultimaker/CuraEngine/build /opt/CuraEngine

ENV CURA_ENGINE_SEARCH_PATH=/defs/
RUN mkdir /defs
COPY --from=defs /src/Cura/resources/extruders/* /defs/
COPY --from=defs /src/Cura/resources/definitions/* /defs/
