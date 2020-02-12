FROM golang:1.13

ARG version

WORKDIR /build
COPY / .

RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build \
    -ldflags="-X=main.version=${version:-unknown}" \
    -o /app \
    ./

FROM alpine

WORKDIR /
COPY --from=0 /app .

RUN apk add --update --no-cache npm nodejs
RUN npm install -g hugo-elasticsearch

CMD ["/app"]
