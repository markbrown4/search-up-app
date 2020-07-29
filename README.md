# Search Up App

A Rails app using the [Up API](https://developer.up.com.au/).
It includes rake tasks for syncing your Up data to a local db and has a simple search and insights.

## Install

```
git clone git@github.com:markbrown4/search-up-app.git
cd search-up-app
bundle install
yarn install
rails db:create
rails db:schema:load
rails server
```

1. Get yourself a token at https://api.up.com.au/getting_started
2. Put it in an `UP_ACCESS_TOKEN` ENV var.
3. Sync your Up data to the local db with `rake up:sync`
4. open http://localhost:3000/transactions

## Deploy

Here's an example of how you can deploy this to [Heroku](https://heroku.com/) and set up Webhooks so it's always up to date.

Checklist:

- Understand the authentication method used: basic http authentication with an Upname / access token in ENV vars.
- Make sure you have a strong password for your heroku account and 2FA enabled.

Install the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install)

```
heroku create
git push heroku master
heroku ps:scale web=1
heroku run rake db:migrate
heroku open
```

Add `UP_NAME` and `UP_ACCESS_TOKEN` ENV vars to the new app in Heroku.
You should see an empty app when you log in with these values, sync the data using the rake task:

```
heroku run rake up:sync
```

Behold! your own personal web app for Up that you can make do amazing things 😎
The app is also webhook capable to keep the accounts / transactions up to date automatically.

From `heroku run rails console` run:

```
Commands::InitWebhook.run(url: 'https://<your-unique-app-name>.herokuapp.com/inbound/event')
```

Make a transfer in Up and it'll show up on the web.
