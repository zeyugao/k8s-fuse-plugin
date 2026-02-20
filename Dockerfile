FROM golang:1.24.3-bookworm AS builder
ARG TARGETOS=linux
ARG TARGETARCH=amd64

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -buildvcs=false -trimpath -ldflags="-s -w" -o /out/k8s-fuse-plugin .

FROM debian:stretch-slim
COPY --from=builder /out/k8s-fuse-plugin /k8s-fuse-plugin
ENTRYPOINT ["/k8s-fuse-plugin"]
