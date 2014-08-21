require "uri"

module AssertUrl
  PARTS = %W[scheme host port path query]

  PARTS.each do |part|
    error = const_set("#{part.capitalize}Error", Class.new(StandardError))

    define_method(:"assert_#{part}") do |expected, value|
      expected, value = urify(expected, value).map(&:"#{part}")

      expected == value || (raise error, "expected #{expected}, got #{value}")
    end
  end

  alias assert_hostname assert_host

  def assert_url(expected, value)
    expected, value = urify(expected, value)

    PARTS.map { |part| send(:"assert_#{part}", expected, value) }.reduce(:&)
  end

  def urify(*args)
    args.each_with_object([]) { |arg, accum| accum << (arg.kind_of?(URI) ? arg : URI(arg)) }
  end
  private :urify
end

