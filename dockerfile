ARG RUBY_VERSION=2.7

FROM ruby:$RUBY_VERSION-alpine as development

RUN apk add --no-cache \
  git build-base yarn nodejs postgresql-dev imagemagick \
  chromium-chromedriver chromium tzdata \
  && rm -rf /var/cache/apk/* 

ENV RAILS_ENV=development
ENV RACK_ENV=development
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_ROOT=/app
ENV LANG=C.UTF-8
ENV GEM_HOME=/bundle
ENV BUNDLE_PATH=$GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH
ENV BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH=/app/bin:$BUNDLE_BIN:$PATH

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler \
  && bundle install -j "$(getconf _NPROCESSORS_ONLN)"  \
  && rm -rf $BUNDLE_PATH/cache/*.gem \
  && find $BUNDLE_PATH/gems/ -name "*.c" -delete \
  && find $BUNDLE_PATH/gems/ -name "*.o" -delete  

COPY package.json yarn.lock ./
RUN yarn install

COPY . ./

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]