FROM ruby:2.4.2-alpine3.6
MAINTAINER Juergen Albertsen <mail@juergenalbertsen.de>

ENV BUILD_PACKAGES="curl-dev ruby-dev build-base" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata sqlite-dev yaml-dev"
RUN apk --update --upgrade add $BUILD_PACKAGES $DEV_PACKAGES

# Install gems
ENV APP_HOME /app
ENV HOME /root
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY app/Gemfile* $APP_HOME/
RUN bundle install

# Upload source
COPY app $APP_HOME/

# Start server
ENV PORT 3000
EXPOSE 3000
CMD ["thin", "-C", "thin.yml", "start"]
