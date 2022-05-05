# bormashino-app-template

template repository of apps with Bormaŝino / SPAs written in Ruby

## Demo

https://bormashino-app-template.vercel.app

## Prerequisites

You need:

- rbenv + ruby-build
- npm
- Vercel CLI (optional, when you want to deploy the app into Vercel)

## Quickstart

in the template dir

```bash
rbenv install 3.2.0-preview1
gem install foreman
bundle install
bundle exec rake bormashino:download
(cd src && bundle install)
npm install
./bin/dev
```

You can see the app at http://localhost:5000/.
App codes are basically in `src/`.
