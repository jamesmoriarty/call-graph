# CallGraph

[![Code Climate](https://codeclimate.com/github/jamesmoriarty/call-graph/badges/gpa.svg)](https://codeclimate.com/github/jamesmoriarty/call-graph) [![Test Coverage](https://codeclimate.com/github/jamesmoriarty/call-graph/badges/coverage.svg)](https://codeclimate.com/github/jamesmoriarty/call-graph/coverage) [![Build Status](https://travis-ci.org/jamesmoriarty/call-graph.svg?branch=master)](https://travis-ci.org/jamesmoriarty/call-graph) [![Gem Version](https://badge.fury.io/rb/call_graph.svg)](https://badge.fury.io/rb/call_graph)

## Why

> The Law of Demeter (LoD) or principle of least knowledge is a design guideline for developing software, particularly object-oriented  programs. In its general form, the LoD is a specific case of loose coupling. The guideline was proposed by Ian Holland at Northeastern  University towards the end of 1987, and can be succinctly summarized in each of the following ways:[1]

> - Each unit should have only limited knowledge about other units: only units "closely" related to the current unit.
> - Each unit should only talk to its friends; don't talk to strangers.
> - Only talk to your immediate friends.

## Usage

Capture the execution you want to graph between `CallGraph.start` and `CallGraph.stop`.

```ruby
class A
  def self.x
    B.new.y
  end
end

class B
  def y
    1 + C.z do
      1
    end
  end
end

class C
  def self.z
    yield
  end
end
```

```ruby
require 'call_graph'

CallGraph.start
A.x
CallGraph.stop
```

Print the captured execution with the provided rake tasks.

```ruby
# Rakefile
load 'call_graph/tasks/printer.rake'
```

```shell
$ rake -T
...
rake call_graph:printer:dot  # write dot file
rake call_graph:printer:png  # write png file from dot file
```

[![Example Graph](https://github.com/jamesmoriarty/call-graph/raw/master/examples/call-graph.png)](https://github.com/jamesmoriarty/call-graph/blob/master/examples/call-graph.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'call_graph'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install call_graph
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/[USERNAME]/call_graph>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
