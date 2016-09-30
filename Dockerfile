FROM resin/edison-node:0.12

# Install packages
RUN apt-get update && apt-get install -y \
	bind9 \
	bridge-utils \
	connman \
	iptables \
	libdbus-1-dev \
	libexpat-dev \
	net-tools \
	udhcpd \
	usbutils \
	wireless-tools \
	&& rm -rf /var/lib/apt/lists/*

COPY ./assets/bind /etc/bind
COPY ./assets/firmware /etc/firmware
COPY ./assets/sbin /usr/sbin

RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app

COPY package.json ./
RUN JOBS=MAX npm install --unsafe-perm --production && npm cache clean

COPY bower.json .bowerrc ./
RUN ./node_modules/.bin/bower --allow-root install \
	&& ./node_modules/.bin/bower --allow-root cache clean

COPY . ./
RUN ./node_modules/.bin/coffee -c ./src
RUN chmod +x ./start

VOLUME /var/lib/connman

CMD ./start
