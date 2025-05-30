FROM instrumentisto/flutter:latest

WORKDIR /app

COPY . .

RUN flutter pub get

EXPOSE 3000

CMD ["flutter", "run"]