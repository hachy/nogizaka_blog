# NogizakaBlog

[![Build Status](https://travis-ci.org/hachy/nogizaka_blog.svg?branch=master)](https://travis-ci.org/hachy/nogizaka_blog)

Get the number of comments and articles per month from Nogizaka46's blog

## Installation

Add this line to your application's Gemfile:

    gem 'nogizaka_blog'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nogizaka_blog

## Usage

```ruby
require 'nogizaka_blog'


nogi = NogizakaBlog::Amazing.new('201508')

nogi.each do |name, comment, article|
  puts "#{name.to_kanji}(#{name}) #{comment} / #{article}"
end
```

Generate JSON example

```ruby
require 'nogizaka_blog'

@nogi = NogizakaBlog::Amazing.new('201508')

p @nogi.member_size

def gen_json
  last = @nogi.member_size - 1
  print '['
  @nogi.each_with_index do |(name, comment, article), idx|
    if idx == last
      print %Q({"name": "#{name.to_kanji}", "comment": #{comment}, "article": #{article}})
    else
      print %Q({"name": "#{name.to_kanji}", "comment": #{comment}, "article": #{article}},)
    end
  end
  print ']'
end

gen_json
```

### CLI

Basic usage in Terminal

	$ nogizaka_blog when YEARMONTH [--sort comment/article]

(e.g. September 2015)

	$ nogizaka_blog when 201509

![screenshots](https://dl.dropboxusercontent.com/u/60760023/screenshots/nogizaka_blog.gif)

## Contributing

1. Fork it ( https://github.com/hachy/nogizaka_blog/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
