assert-url
==========

Semantical helpers to test your URLs in Ruby

## Usage

Ok, say you're writing a Web app with Ruby (who isn't?) and need to test your routing with `Rack::Test`.

### The old way

```ruby
def test_some_place
  get "/some/place"

  assert last_response.ok?
  assert_equal "http://example.org/some/place", last_response.url
end
```

What's wrong with this, you ask? Well, here you only care about testing the `/some/place` path, but the rest (scheme, port, etc) doesn't really matter. Still we're used to using `assert_equal` on the whole url.

Now imagine that you need to change the port, scheme or host. Now imagine you have hundreds of tests. It's `grep` day, my friend.

### Enter AssertUrl!

```ruby
include AssertUrl

def test_some_place
  get "/some/place"

  assert last_response.ok?
  assert_path "http://dont.care.org/some/place", last_response.url
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
