FROM gcr.io/distroless/base
COPY /kmscrypter /kmscrypter
ENTRYPOINT ["/kmscrypter"]
