#!/bin/sh

GEM_NAME="$1"

case $GEM_NAME in
  *metrics-sdk)
    echo "metrics-sdk"
    GEM_PATH="metrics_sdk/"
    ;;
  *metrics-api)
    echo "metrics-api"
    GEM_PATH="metrics_api/"
    ;;
  *exporter-otlp)
    echo "exporter-otlp"
    GEM_PATH="exporter/otlp/"
    ;;
  *)
    echo "Unknown file type"
    GEM_PATH='nowhere'
    ;;
esac

cd "$GEM_PATH" || exit 1

bundle install

# get gem version using bash
file_to_find="version.rb"
found_file=$(find "." -type f -name "$file_to_find")
gem_version=$(grep -E "VERSION\s*=\s*'[^']+'" "$found_file" | awk -F "'" '{print $2}')

# build and push gem
gem build "opentelemetry-$GEM_NAME.gemspec"
# gem push --key github --host https://rubygems.pkg.github.com/solarwinds "opentelemetry-instrumentation-$GEM_NAME-$gem_version.gem"

# finished
echo "Finished"
