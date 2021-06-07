FROM ubuntu:20.04

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		gpg \
		gpg-agent \
	; \
	rm -rf /var/lib/apt/lists/*

ARG VERSION

RUN curl --output /tmp/dashcore.tar.gz -L https://github.com/dashpay/dash/releases/download/v${VERSION}/dashcore-${VERSION}-x86_64-linux-gnu.tar.gz ; \
    curl --output /tmp/dashcore.tar.gz.asc -L https://github.com/dashpay/dash/releases/download/v${VERSION}/dashcore-${VERSION}-x86_64-linux-gnu.tar.gz.asc ; \
    curl https://keybase.io/codablock/pgp_keys.asc | gpg --import ; \
    curl https://keybase.io/pasta/pgp_keys.asc | gpg --import ; \
    gpg --verify /tmp/dashcore.tar.gz.asc ; \
    tar -xz --keep-old-files -f /tmp/dashcore.tar.gz --strip-components=1 -C /

RUN useradd -m -u 1000 -s /bin/bash runner
USER runner

ENTRYPOINT ["dashd"]
