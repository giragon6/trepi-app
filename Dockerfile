FROM nginx:alpine

RUN apk add --no-cache bash curl git unzip

RUN cd /tmp && \
    curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz && \
    tar xf flutter_linux_3.16.0-stable.tar.xz && \
    mv flutter /opt/

ENV PATH="/opt/flutter/bin:${PATH}"

WORKDIR /app
COPY . .

RUN flutter config --enable-web --no-analytics
RUN flutter pub get
RUN flutter build web --release

RUN cp -r build/web/* /usr/share/nginx/html/

RUN echo 'server {\n\
    listen 3000;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    \n\
    location / {\n\
        try_files $uri $uri/ /index.html;\n\
    }\n\
}' > /etc/nginx/conf.d/default.conf

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]