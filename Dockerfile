# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.3.8
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Install base production system dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    libsodium-dev \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Build stage for compiling gems and assets
FROM base AS build
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git

COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

COPY . .

# Final lightweight layer
FROM base
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
