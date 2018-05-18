FROM alpine:latest

# Install dependencies
RUN apk add --update --no-cache \
    bash \
	git \
	openssh \
	python3 \
	python3-dev \
	gcc \
	build-base \
	linux-headers \
	curl \
    libffi \
    libffi-dev \
    openssl \
    openssl-dev \
    iputils
#    pcre-dev \
#    musl-dev \
#    libxml2-dev \
#    libxslt-dev \
#    nginx \
#    supervisor

# setup python3 and pip
RUN python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

# install django, djangorestframework, uwsgi
RUN pip install "django>=2" djangorestframework uwsgi

# install openstack client and optional clients
ADD install_clients.sh /tmp/
RUN /tmp/install_clients.sh magnum senlin zaqar zun

# Cleanup
RUN apk del build-base linux-headers python-dev libffi-dev openssl-dev
RUN rm -rf /var/cache

# deploy app
RUN mkdir -p /app
WORKDIR /app

# expose web client's port
EXPOSE 8000

CMD ["sh"]
#CMD uwsgi --http-socket :9000 --master --module app:app --pythonpath /var/app

