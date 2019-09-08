FROM ruby:2.6-alpine

LABEL maintainer="Savedo GmbH <it@savedo.de>"

RUN apk update \
    && apk upgrade \
    && apk add --upgrade build-base git libxml2-dev libxslt-dev sqlite-dev \
    && rm -rf /var/cache/apk/*

ENV APP_HOME /usr/src/app

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* ./
RUN bundle install

COPY . $APP_HOME

CMD ["bundle", "exec", "ruby", "scraper.rb"]
