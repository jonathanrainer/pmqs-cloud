FROM rust:1.74 as build

# create a new empty shell project
RUN mkdir /build
WORKDIR /build

# copy over your manifests
COPY . .

# build for release
RUN cargo build --release

# our final base
FROM debian:bookworm-slim

ENV APP_NAME="humphery"

RUN apt-get update && apt-get upgrade -y

RUN apt-get install libssl3 ca-certificates -y

# copy the build artifact from the build stage
COPY --from=build ./build/target/release/$APP_NAME /usr/local/bin/.

WORKDIR /

# set the startup command to run your binary
ENTRYPOINT ["humphery"]