FROM phusion/passenger-ruby22

RUN gem install cloudformation-ruby-dsl -v 0.4.9

ADD . /app
WORKDIR /app

ENTRYPOINT ["./jenkins-slave.rb"]
CMD ["expand"]
