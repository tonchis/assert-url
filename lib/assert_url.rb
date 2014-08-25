require "uri"

module AssertUrl
  PARTS = %W[scheme host port path query fragment].each do |part|
    const_set("#{part.capitalize}Error", Class.new(StandardError))
  end

  # @param [String or Symbol] expected The scheme the url should have.
  # @param [String or URI] value The url you wish to validate.
  #
  # @example
  #
  #   assert_scheme_equal(:http, "http://example.org")
  #   assert_scheme_equal("http", "http://example.org")
  #
  def assert_scheme_equal(expected, value)
    value = urify(value).scheme

    expected.to_s == value || raises(SchemeError, expected, value)
  end

  # @param [String] expected The host the url should have.
  # @param [String or URI] value The url you wish to validate.
  #
  # @example
  #
  #   assert_host_equal("example.org", "http://example.org")
  #
  def assert_host_equal(expected, value)
    value = urify(value).host

    expected == value || raises(HostError, expected, value)
  end

  # @param [Integer] expected The port the url should have.
  # @param [String or URI] value The url you wish to validate.
  #
  # @example
  #
  #   assert_port_equal(80, "http://example.org")
  #
  def assert_port_equal(expected, value)
    value = urify(value).port

    expected == value || raises(PortError, expected, value)
  end

  # @param [String] expected The path the url should have.
  # @param [String or URI] value The url you wish to validate.
  #
  # @example
  #
  #   assert_path_equal("/path", "http://example.org/path")
  #
  def assert_path_equal(expected, value)
    value = urify(value).path

    expected == value || raises(PathError, expected, value)
  end

  # The comparison is "String vs Symbol" safe for the keys.
  #
  # @param [Hash] expected The query the url should have.
  # @param [String or URI] value The url you wish to validate.
  #
  # @example
  #
  #   assert_query_equal({foo: "bar"}, "http://example.org/?foo=bar")
  #
  def assert_query_equal(expected, value)
    value = urify(value).query
    expected = (URI.encode_www_form(expected) rescue expected)

    expected == value || raises(QueryError, expected, value)
  end

  # @param [String] expected The fragment the url should have.
  # @param [String or URI] value The url you wish to validate.
  #
  # @example
  #
  #   assert_fragment_equal("fragment", "http://example.org/path#fragment")
  #
  def assert_fragment_equal(expected, value)
    value = urify(value).fragment

    expected == value || raises(FragmentError, expected, value)
  end

  # {#assert_url_equal} runs all the validations above. It's not a String comparison.
  #
  # @param [String or URI] expected The url you wish to have.
  # @param [String or URI] value The url you wish to validate.
  #
  # @example
  #
  #   assert_url_equal(URI("http://example.org"), "http://example.org")
  #
  def assert_url_equal(expected, value)
    expected, value = urify(expected), urify(value)

    PARTS.map { |part| send(:"assert_#{part}_equal", expected.send(part.to_sym), value) }.reduce(:&)
  end

  # The comparison is "String vs Symbol" safe for the keys.
  #
  # @param [String or Symbol] expected The key-value pairs that the url must include.
  # @param [String or URI] value The url you wish to validate.
  #
  # @example
  #
  #   assert_query_include({foo: "bar"}, "http://example.org/?foo=bar&baz=wat")
  #
  def assert_query_include(expected, value)
    value = Hash[URI.decode_www_form(urify(value).query)]

    validation = -> { includes?(expected.to_a, value) }

    cutest_or_standalone(validation, [QueryError, "expected #{value} to include #{expected}"])
  end

  def cutest_or_standalone(validation, error)
    if defined?(Cutest)
      cutest_eval do
        validation.() || (throw :cutest_fail, error.last)
      end
    else
      validation.() || (raise *error)
    end
  end

  def includes?(expected, got)
    expected.all? do |(key, value)|
      key = key.to_s
      got.has_key?(key) && got[key] == value
    end
  end
  private :includes?

  def urify(arg)
    arg.kind_of?(URI) ? arg : URI(arg)
  end
  private :urify

  def raises(error, expected, value)
    raise error, "expected #{expected}, got #{value}"
  end
  private :raises
end

