FROM ruby:3.2-alpine 
WORKDIR /src
COPY Gemfile /src/Gemfile
COPY app.rb /src/app.rb 
RUN bundle install
CMD ["ruby", "/src/app.rb"]