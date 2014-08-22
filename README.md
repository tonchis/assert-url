assert-url
==========

Semantical helpers to test your URLs in Ruby

## Usage

Ok, say you're writing a Web app with Ruby (who isn't?) and need to test your routing with `Rack::Test`.

### The old way

```ruby
def test_some_resource
  get "/some/resource"

  assert last_response.ok?
  assert_equal "http://example.org/some/resource", last_response.url
end
```

What's wrong with this, you ask? Well, in most cases when you write a test like this, you only care about testing the `/some/resource` path, but the rest (scheme, port, etc) doesn't really matter. Still we're used to use `assert_equal` on the whole url.

Now imagine that you need to change the port, scheme or host. Now imagine you have hundreds of tests. It's `grep` day, my friend.

### Enter AssertUrl!

```ruby
include AssertUrl

def test_some_resource
  get "/some/resource"

  assert last_response.ok?
  assert_path "http://dont.care.org/some/resource", last_response.url
end
```

Now you can change the port, host, even the query and the test will be fine.

`AssertUrl` provides the following methods:
* `assert_scheme`
* `assert_host`
* `assert_port`
* `assert_path`
* `assert_query`
* `assert_url`

And you can send `String` or `URI` objects to them.

### But...

Can't I just do something like...?

```ruby
assert_equal "/some/resource", URI(last_response.url).path
```

Well, yes! sure you can. In fact, this is very close to how `AssertUrl` is implemented.

My point here is not to sell you this gem but to make a statement that we need a better habit when testing URLs. And if `AssertUrl` helps you with it, great!

## Installation

```
gem install assert-url
```
