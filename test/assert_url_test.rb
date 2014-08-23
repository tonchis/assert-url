require "cutest"
require "uri"
require_relative "../lib/assert_url"

include AssertUrl

setup do
  "http://sub.example.org:8080/path/to/resource?foo=bar#fragment"
end

test "assert_scheme_equal" do |url|
  assert assert_scheme_equal("http", url)
  assert assert_scheme_equal(:http, url)

  assert_raise(AssertUrl::SchemeError) do
    assert_scheme_equal("ftp", url)
  end
end

test "assert_host_equal" do |url|
  assert assert_host_equal("sub.example.org", url)

  assert_raise(AssertUrl::HostError) do
    assert_host_equal("example.org", url)
  end
end

test "assert_port_equal" do |url|
  assert assert_port_equal(8080, url)

  assert_raise(AssertUrl::PortError) do
    assert_port_equal(80, url)
  end
end

test "assert_path_equal" do |url|
  assert assert_path_equal("/path/to/resource", url)

  assert_raise(AssertUrl::PathError) do
    assert_path_equal("/not/the/resource", url)
  end
end

test "assert_query_equal" do |url|
  assert assert_query_equal({foo: "bar"}, url)

  assert_raise(AssertUrl::QueryError) do
    assert_query_equal("", url)
  end
end

test "assert_query_include" do
  assert assert_query_include({foo: "bar"}, "http://example.org/?foo=bar&baz=wat")

  assert_raise(AssertUrl::QueryError) do
    assert_query_include({foo: "wat"}, "http://example.org/?foo=bar&baz=wat")
  end
end

test "assert_fragment_equal" do |url|
  assert assert_fragment_equal("fragment", url)

  assert_raise(AssertUrl::FragmentError) do
    assert_fragment_equal("not", url)
  end
end

test "assert_url_equal" do |url|
  assert assert_url_equal(url, url)

  assert_raise do
    assert_url_equal("https://example.org", url)
  end
end
