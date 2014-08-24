require "uri"

module AssertUrl
  PARTS = %W[scheme host port path query fragment].each do |part|
    const_set("#{part.capitalize}Error", Class.new(StandardError))
  end

  def assert_scheme_equal(expected, value)
    value = urify(value)

    expected.to_s == value.scheme || raises(SchemeError, expected, value)
  end

  def assert_host_equal(expected, value)
    value = urify(value)

    expected == value.host || raises(HostError, expected, value)
  end

  def assert_port_equal(expected, value)
    value = urify(value)

    expected == value.port || raises(PortError, expected, value)
  end

  def assert_path_equal(expected, value)
    value = urify(value)

    expected == value.path || raises(PathError, expected, value)
  end

  def assert_query_equal(expected, value)
    value = urify(value)
    expected = (URI.encode_www_form(expected) rescue expected)

    expected == value.query || raises(QueryError, expected, value)
  end

  def assert_fragment_equal(expected, value)
    value = urify(value)

    expected == value.fragment || raises(FragmentError, expected, value)
  end

  def assert_url_equal(expected, value)
    expected, value = urify(expected), urify(value)

    PARTS.map { |part| send(:"assert_#{part}_equal", expected.send(part.to_sym), value) }.reduce(:&)
  end

  def assert_query_include(expected, value)
    value = Hash[URI.decode_www_form(urify(value).query)]

    includes?(expected.to_a, value) || (raise QueryError, "expected #{value} to include #{expected}")
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

