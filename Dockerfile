FROM --platform=$BUILDPLATFORM golang:1.25-alpine AS builder

ARG TARGETOS
ARG TARGETARCH

RUN apk add --no-cache ca-certificates git

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . .
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -trimpath -ldflags="-s -w" -o /bin/agent-gateway .

FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /app
COPY --from=builder /bin/agent-gateway /bin/agent-gateway
COPY config ./config

EXPOSE 5010

USER nonroot:nonroot
ENTRYPOINT ["/bin/agent-gateway"]
CMD ["--config=./config/dev/config.yaml"]
