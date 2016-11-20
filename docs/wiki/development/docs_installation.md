---
title: Documentation Installation
---

## Installing prerequisites

### Windows (CMD)

- Install [Ruby 2.3.1 (x64)](http://rubyinstaller.org/downloads/)
- Install [Ruby DevKit for 2.0 and above (x64)](http://rubyinstaller.org/downloads/)
- Install [NodeJS](https://nodejs.org/download/)
- Open Command Prompt and navigate to this directory
    ```
    cd <ACRE2_directory>/docs
    ```

- Install `bundler` and `jekyll` gems
    ```
    gem install bundler jekyll
    ```

- Install required gems through `bundler`
    ```
    bundle install
    ```

### Debian / Bash on Ubuntu on Windows

- Open Bash and navigate to this directory
    ```
    cd <ACRE2_directory>/docs
    ```

- Install `make`, `gcc` and `nodejs`
    ```
    sudo apt-get install make gcc nodejs
    ```

- Install `ruby2.3`, `rbuy2.3-dev` and `ruby-switch`
    ```
    sudo apt-add-repository ppa:brightbox/ruby-ng
    sudo apt-get update
    sudo apt-get install ruby2.3 ruby2.3-dev ruby-switch
    ```

- Set Ruby version
    ```
    sudo ruby-switch --set ruby2.3
    ```

- Install `bundler` and `jekyll`
    ```
    sudo gem install bundler jekyll
    ```

- Install required gems through bundler
    ```
    bundle install
    ```

- In case of sticky folder error during `bundle install`, execute the following to fix permissions
    ```
    find ~/.bundle/cache -type d -exec chmod 0755 {} +
    ```

## Running

- Run Jekyll through bundler
    ```
    bundle exec jekyll serve --future --incremental --config _config_dev.yml
    ```
    _Use `--force_polling` on Bash on Ubuntu on Windows due to a bug preventing watching._

- Navigate to http://localhost:4005

