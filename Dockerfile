FROM allanklaus/ruby:2.7.1

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && \
    apt-get install -y --force-yes --no-install-recommends \
      git \
      wget \
      curl \
      equivs \
      procps \
      locales \
      debhelper \
      devscripts \
      mysql-client \
      openssh-client \
      git-buildpackage \
      libmysqlclient-dev \
      apt-transport-https \
      software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# INSTALL NODE
RUN wget --quiet -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb https://deb.nodesource.com/node_11.x stretch main" > /etc/apt/sources.list.d/node.list
RUN apt-get update -qq && \
    apt-get install -y --force-yes --no-install-recommends \
      nodejs && \
    rm -rf /var/lib/apt/lists/*

# INSTALL YARN
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    apt-get install -y --force-yes --no-install-recommends \
      yarn && \
    rm -rf /var/lib/apt/lists/*

ENV APP_HOME /ecommerce
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN gem install bundler
RUN bundle config build.nokogiri --use-system-libraries

RUN bundle install
RUN yarn

CMD /bin/bash -l -c "bundle install; yarn; bundle exec rake assets:precompile"

