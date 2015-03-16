FROM ruby:2.1.5
RUN gem install bundler --pre
ENV NO_COLOR=1

ADD . /gem
WORKDIR /gem
RUN bundle install
CMD ["bin/rake", "test"]

