FROM docker.io/library/golang:1.25.0 as build
COPY ./gears/main.go /build/gears/
WORKDIR /build/
# - 
RUN go mod init server \
 && go mod tidy \
 && go mod download \
 && go mod verify \
 && go build -C /build/gears -o /go/bin/server  ./main.go
# -
FROM docker.io/library/golang:1.25.0
RUN useradd -s /sbin/nologin -r -m httpd
COPY --from=build /go/bin/server /usr/bin/server
COPY ./webroot /opt/webroot
WORKDIR /opt/webroot
EXPOSE 8080 
CMD [ "/usr/bin/server" ]
