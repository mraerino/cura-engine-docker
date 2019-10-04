FROM registry.gitlab.com/ultimaker/cura/cura-build-environment:centos7 as build

ARG VERSION=4.3.0
ADD --chown=ultimaker https://github.com/Ultimaker/CuraEngine/archive/${VERSION}.tar.gz ./cura-engine.tar.gz

USER ultimaker
RUN tar -xzf cura-engine.tar.gz
RUN mv CuraEngine-${VERSION} CuraEngine && cd CuraEngine && ./docker/build.sh

FROM centos:7

COPY --from=build /usr/lib64/libgomp.so.1.0.0 /usr/lib64/
RUN cd /usr/lib64; ln -s libgomp.so.1.0.0 libgomp.so.1
COPY --from=build /home/ultimaker/CuraEngine/build /opt/CuraEngine
