#Ldfwrapper [![Version](https://badge.fury.io/gh/projecthydra%2Fjettywrapper.png)](http://badge.fury.io/gh/boston-library%2Fldf-jetty) [![Build Status](https://travis-ci.org/boston-library/ldf-jetty.png?branch=master)](https://travis-ci.org/boston-library/ldf-jetty)

This gem is designed to make it easier to integrate a jetty servlet container into a project with web service dependencies.  This can be especially useful for developing and testing projects requiring, for example, a Marmotta and/or Blazegraph backend.

Ldfwrapper provides rake tasks for starting and stopping jetty, as well as the method `Ldfwrapper.wrap` that will start the server before the block and stop the server after the block, which is useful for automated testing.

LdfWrapper is essentially a reskin of Jettywrapper uses ldf-jetty by default.

## Requirements

1.  ruby -- Ldfwrapper supports the ruby versions in its [.travis.yml](.travis.yml) file.
2.  bundler -- this ruby gem must be installed.
3.  java -- Jetty is a java based servlet container; the version of java required depends on the version of jetty you are using (in the jetty-based zip file).

## Installation

Generally, you will only use a jetty instance for your project's web service dependencies during development and testing, not for production. So you would add this to your Gemfile:

```
group :development, :test do
  gem 'ldfwrapper'
end
```

Or, if your project is a gem, you would add this to your .gemspec file:

```
Gem::Specification.new do |s|
  s.add_development_dependency 'ldfwrapper'
end
```

Then execute:

    $ bundle

Or install it yourself as:

    $ gem install ldfwrapper


## Usage

### Configuration

See [Configuring jettywrapper](https://github.com/projecthydra/jettywrapper/wiki/Configuring-jettywrapper).

### Gotchas

* Jetty may take a while to spin up
* Jetty may not shut down cleanly

See [Using jettywrapper](https://github.com/projecthydra/jettywrapper/wiki/Using-jettywrapper) for more information and what to do.

### Example Rake Task

See [Using jettywrapper](https://github.com/projecthydra/jettywrapper/wiki/Using-jettywrapper) for more information.

```ruby
require 'ldfwrapper'

desc 'run the tests for continuous integration'
task ci: ['ldfjetty:clean', 'myproj:configure_jetty'] do
  ENV['environment'] = 'test'
  jetty_params = Ldfwrapper.load_config
  jetty_params[:startup_wait] = 60

  error = nil
  error = Ldfwrapper.wrap(jetty_params) do
    # run the tests
    Rake::Task['spec'].invoke
  end
  raise "test failures: #{error}" if error
end
```

## Contributing

See [CONTRIBUTING.md](https://github.com/boston-library/ldf-jetty/blob/master/CONTRIBUTING.md) to help us make this project better.