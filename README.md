# TL;DR

A crude playground for experimenting with Capybara.

Run ./INSTALL

# Notes

I had to install the chrome driver from here:

  http://chromedriver.storage.googleapis.com/2.24/chromedriver_mac64.zip

I got to that URL by looking at the LATEST_RELEASE here:

  http://chromedriver.storage.googleapis.com/index.html

I installed the executable into ./bin and added ./bin to my path

To install PhantomJS, run

  $ npm install

You will want to add the chrome driver and the `phantomjs` binary to
your path. The simple but dangerous way to do this is:

  $ PATH=./bin:./node_modules/.bin:$PATH

To run the sinatra app in a way that automatically reloads changes:

  $ bundle exec rerun app.rb
