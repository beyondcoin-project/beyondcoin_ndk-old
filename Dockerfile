FROM debian:stretch@sha256:724b0fbbda7fda6372ffed586670573c59e07a48c86d606bab05db118abe0ef5
COPY /stretch_deps.sh /
RUN /stretch_deps.sh
