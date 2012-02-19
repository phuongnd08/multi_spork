# multi_spork: Run cucumber or rspec tests in parallel with spork

# Intro #
Spork is awesome for running cucumber and rspec tests as it cuts time on loading the whole frame work
However, with the multicore architect so common nowadays, running tests in one single process is a waste.
There are solution out there like parallel_tests but parallel is not taking advantage of process forking
multi_spork is taking idea from parallel_tests, and it stack over forking model of spork as well.

# Installation #
## Change the Gemfile ##
I'll be releasing multi_spork to rubygems soon. But in the mean time, you can try it by including this in your Gemfile:

gem 'multi_spork', :git => "git://github.com/phuongnd08/multi_spork.git"

Make sure you put the gem inside :development group as it is necessary for Rails to pickup the rake task later

Also, for multi_spork to work, it needs Spork to provide some information about the current fork (so it can rotate database connections)
I have sent a pull request to spork owner but in the mean time, you can try using this forked one

gem 'spork', :git => "git://github.com/phuongnd08/spork.git", :branch => "v0.9.x"

By default, multi_spork will run with a number of workers equal to the number of processor your sysem have. Feel free to
change it by creating config/multi_spork.rb in your Rails project and put something like this into it:

    multi_spork.configure do |config|
      config.worker_pool = 8
    end

## Prepare databases ##
There will be a need for multiple databases so that multi_spork can launch multiple test runner in parallel without conflict

Prepare your test databases with

    $ rake db:multi_spork:clone

This will generate a number of test databases, currently only work if you use ActiveRecord
as your database provider. Support for Mongoid and other databased provider may come later

## Modify your bootstrap ##
You need to change your env.rb and spec_helper.rb

In order for multi_spork to behave properly, it needs to disconnect the default ActiveRecord
connection and re-establish a different one for each worker.

You need to allow multi_spork to do that by replacing:

- require 'spork' with require 'multi_spork' (multi_spork will require spork then)

- Spork.prefork with MultiSpork.prefork

- Spork.each_run with MultiSpork.each_run

## Reboot your drb server ##
Now make sure your Drb server rebooted

# Run the test #
- To run your features in parallel:
    $ bundle exec multi_cuke features/

- To run your specs in parallel:
    $ bundle exec multi_rspec spec/

# Uninstall? #
In case you don't think multi_spork is good for you, revert any changes you have made.
Furthermore, you can drop all databases created by multi_spork with this command:

    $ bundle exec rake db:multi_spork:drop
