FROM ruby:3.2.2

#===================
# packageセットアップ
#===================
RUN apt-get update && apt-get install -y \
  nodejs \
  npm \
  default-mysql-client \
  less \
  vim \
  curl \
  sudo

RUN npm i -g n && n 20.0.0

#======================
# プロジェクトセットアップ
#======================
WORKDIR /app

# gem
COPY volumes/backend/Gemfile* .
RUN bundle install

# TODO: esbuildなどでnpmパッケージが必要になったタイミングで有効化
# node_modules
# COPY volumes/backend/package.json .
# COPY volumes/backend/package-lock.json .
# RUN npm i

# TODO: 起動方法をentrypoint.shにまとめるタイミングで有効化
# entrypoint
# COPY containers/backend/scripts/entrypoint.sh /entrypoint.sh
# RUN chmod 755 /entrypoint.sh
# CMD ["/entrypoint.sh"]

CMD ["rails", "s", "-p", "3000", "-b", "0.0.0.0"]

EXPOSE 3000
