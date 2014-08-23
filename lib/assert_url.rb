require "uri"

module AssertUrl
  PARTS = %W[scheme host port path query fragment]

  PARTS.each do |part|
    error = const_set("#{part.capitalize}Error", Class.new(StandardError))

    define_method(:"assert_#{part}_equal") do |expected, value|
      expected = normalize(part, expected)
      value = urify(value).send(part.to_sym)

      expected == value || (raise error, "expected #{expected}, got #{value}")
    end
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

  def normalize(part, expected)
    case part
    when "scheme"
      expected.kind_of?(Symbol) ? expected.to_s : expected
    when "query"
      URI.encode_www_form(expected) rescue expected
    else
      expected
    end
  end
  private :normalize
end

