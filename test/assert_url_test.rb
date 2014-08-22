require "cutest"
require "uri"
require_relative "../lib/assert_url"

include AssertUrl

setup do
  "http://sub.example.org:8080/path/to/resource?foo=bar"
end

test "assert_url" do |url|
  assert assert_url(url, url)

  assert_raise do
    assert_url("https://example.org", url)
  end
end

test "assert_scheme" do |url|
  assert assert_scheme("http://example.org", url)

  assert_raise(AssertUrl::SchemeError) do
    assert_scheme("ftp://example.org", url)
  end
end

test "assert_host" do |url|
  assert assert_host("https://sub.example.org", url)

  assert_raise(AssertUrl::HostError) do
    assert_host("http://example.org", url)
  end
end

test "assert_port" do |url|
  assert assert_port("http://place.org:8080", url)

  assert_raise(AssertUrl::PortError) do
    assert_port("ftp://example.org", url)
  end
end

test "assert_path" do |url|
  assert assert_path("http://wat.org/path/to/resource", url)

  assert_raise(AssertUrl::PathError) do
    assert_path("ftp://example.org", url)
  end
end

test "assert_query" do |url|
  assert assert_query("http://foo.bar/q?foo=bar", url)

  assert_raise(AssertUrl::QueryError) do
    assert_query("ftp://example.org", url)
  end
end

