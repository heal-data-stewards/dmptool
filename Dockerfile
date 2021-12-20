# syntax=docker/dockerfile:1
FROM ruby:2.6.8

RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash -
RUN apt-get update -qq \
    && apt-get install -y \
        nano \
        nodejs \
        postgresql-client \
        imagemagick \
        # python3 \
        # build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN npm install --global yarn

# Install ImageMagick and libraries
# RUN rpm -Uvh ImageMagick-7.1.0-13.x86_64.rpm \
#     && rpm -Uvh ImageMagick-libs-7.1.0-13.x86_64.rpm

WORKDIR /roadmap

COPY Gemfile /roadmap/Gemfile
COPY Gemfile.lock /roadmap/Gemfile.lock

RUN gem install bundler \
    && bundle install

COPY . /roadmap

RUN rake yarn:install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
