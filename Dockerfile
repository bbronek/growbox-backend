FROM ruby:3.2.0

ENV APP_HOME /growbox-backend
WORKDIR $APP_HOME

COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
