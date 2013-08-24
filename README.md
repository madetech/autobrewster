# AutoBrewster

[![Build Status](https://travis-ci.org/madebymade/autobrewster.png?branch=master)](https://travis-ci.org/madebymade/autobrewster)
[![Gem Version](https://badge.fury.io/rb/autobrewster.png)](http://badge.fury.io/rb/autobrewster)

AutoBrewster is a Rubygem that provides regression testing for your CSS. How it works:

1. AutoBrewster should be first run to generate source screenshots. You should manually validate these screenshots as your known good state.
2. Every time you make a change to your application, run AutoBrewster to compare the current state of the application against the source state.
3. If anything has changed, AutoBrewster will tell you.
4. If the changes were deliberate, replace the source screenshot for that page with the current state.
5. If the changes were not deliberate, fix the regression and rerun AutoBrewster.

## Credits

* Much of the test server launching implementation comes from [Capybara](https://github.com/jnicklas/capybara)
* Much of the screenshot capturing implementation comes from [Wraith](https://github.com/bbc-news/wraith)

##License

Licensed under [New BSD License](http://opensource.org/licenses/BSD-3-Clause)