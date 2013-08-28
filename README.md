# AutoBrewster

[![Build Status](https://travis-ci.org/madebymade/autobrewster.png?branch=master)](https://travis-ci.org/madebymade/autobrewster)
[![Gem Version](https://badge.fury.io/rb/autobrewster.png)](http://badge.fury.io/rb/autobrewster)

AutoBrewster is a Rubygem that provides regression testing for your CSS. It's got out of the box support for launching and testing Rack applications; though you can configure it to test against any host.

How it works:

1. AutoBrewster should be first run to generate source screenshots of your application. You should manually validate these screenshots as your known good state.
2. Every time you make a change to your application, run AutoBrewster to compare the current state of the application against the source state.
3. If anything has changed, AutoBrewster will tell you.
4. If the changes were deliberate, replace the source screenshot for that page with the current state.
5. If the changes were not deliberate, fix the regression and rerun AutoBrewster.

## Requirements

AutoBrewster has the following binary dependencies:

* [PhantomJS](http://phantomjs.org/)
* [ImageMagick](http://www.imagemagick.org/)

## Running AutoBrewster

Once AutoBrewster is installed, you should run the following command from the root of your application: `autobrewster generate_source_screens`

This should be run the first time only to capture the source screenshots. By default this will be output to `test/brewster/screens`. These should be checked in to your source control repository for future comparisons.

Next, make a change that will affect the output and run AutoBrewster without any arguments: `autobrewster`

This will capture the current state of the application and compare this against the source state. If anything has changed AutoBrewster will exit with a status of 1 and tell you what doesn't match. You'll find a screenshot of the current state in the `compare` directory and a diff of the source and current state in the `diff` directory.

## Test environment

AutoBrewster will need to be able to connect to a test server running on a port to be able to capture screenshots.

AutoBrewster is configured out of the box to launch a rack server in test mode. (by default it assumes you have a `config.ru` in the same directory as AutoBrewster is being run). You can disable this and choose to launch your own test server, in which case you'll need to give AutoBrewster a hostname it can connect to.

## Structure

AutoBrewster expects a particular file structure from the root of your application. At present your should create this file structure yourself.

```
.
└── test
   └── autobrewster
      └── support
         ├── pre_launch
         ├── post_launch
         └── env.rb
```

* `pre_launch` all files with a `.rb` extension in this directory will be executed prior to the test run. This is useful for mocking out web service interfaces and other things that don't require your application framework.
* `post_launch` all files with a `.rb` extension in this directory will be executed prior to the test server being launched. This is useful for things like factories that do require your application framework.
* `env.rb` will be loaded as soon as AutoBrewster starts. This is the place to override default configuration values, require external libraries and the like.

## Configuration

AutoBrewster provides the following default configuration:

```ruby
  AutoBrewster.configure do |config|
    config.server_start = true
    config.server_port = 5001
    config.path = "#{Dir.pwd}/test/brewster"
    config.rackup_path = 'config.ru'
    config.server {|app, port| AutoBrewster.run_default_server(app, port)}
    config.server_timeout = 10
    config.hostname = false
    config.debug = true
    config.failfast = false
    config.screen_widths = [320, 1024]
    config.url_paths = {
      :home => '/'
    }
end
```

To override part of the configuration, you should redefine the configuration block in `test/autobrewster/support/env.rb`.

* `server_start` set to false to prevent AutoBrewster launching a rack server in test mode.
* `server_port` specifies the port AutoBrewster will launch the rack test server on.
* `path` path where support files should be found and where output screenshots will be stored.
* `rackup_path` relative path to rackup file.
* `server` by default AutoBrewster will launch a thin server. If you want to use something else, pass a block to this function implementing a different rack server (such as Webrick).
* `server_timeout` how long to wait in seconds for the test server to start.
* `hostname` if AutoBrewster doesn't launch a rack server, you'll need to pass the hostname that AutoBrewster should connect to.
* `debug` will trigger the default server runner to make a bit more noise.
* `failfast` will exit the task with a status of 1 as soon as it encounters a screenshot that doesn't match, rather than continuing with the test run to show all of the screenshots that don't match. Useful for CI environments; where you typically wouldn't expect any failures.
* `screen_widths` an array of widths that AutoBrewster should capture and compare screenshots for. Useful for testing responsive designs.
* `url_paths` a hash containing friendly labels and URL paths that AutoBrewster should capture and compare screenshots for.

## Known Issues

If you have a team who develop on different platforms (or if your CI server runs a different platform), you're likely to see false positives around font rendering. We're open to suggestions on how this might be solved.

As an aside, we'd heartily recommend moving your development estate to something like [Vagrant](http://vagrantup.com/) to get better development/production parity. And for a host of other reasons.

## Credits

* Much of the rack server launching implementation comes from [Capybara](https://github.com/jnicklas/capybara)
* Much of the screenshot capturing implementation comes from [Wraith](https://github.com/bbc-news/wraith)

##License

Licensed under [New BSD License](http://opensource.org/licenses/BSD-3-Clause)