FROM ruby:2.1.5
ADD . /gem
RUN gem install bundler --pre
WORKDIR /gem
RUN bundle install

CMD ["bin/rake", "test"]

