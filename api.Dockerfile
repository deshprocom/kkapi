FROM ruby:2.5.0

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
  mysql-client nodejs imagemagick

WORKDIR /app

RUN gem install bundler
COPY Gemfile Gemfile.lock /app/
RUN bundle install
COPY . /app/

CMD ["bin/rails", "s", "-b", "0.0.0.0"]