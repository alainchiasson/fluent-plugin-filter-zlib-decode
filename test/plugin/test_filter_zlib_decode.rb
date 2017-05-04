require_relative '../test_helper'

class ZlibDecodeFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
    @time = Fluent::Engine.now
  end

  CONFIG = %[
    fields field1,field2
  ]

  def create_driver(conf=CONFIG)
    Fluent::Test::FilterTestDriver.new(Fluent::ZlibDecodeFilter).configure(conf, true)
  end

  def emit(config, record)
    d = create_driver(config)
    d.run {
      d.emit(record, @time)
    }.filtered
  end

  test 'configure' do
    d = create_driver(CONFIG)
    assert_equal ['field1', 'field2'], d.instance.fields
  end

  test 'decode' do
    es = emit(CONFIG, {
                'field1' => "x\x9C\xCBH\xCD\xC9\xC9\a\x00\x06,\x02\x15",
                'field3' => "x\x9C\xCBH\xCD\xC9\xC9\a\x00\x06,\x02\x15"
              })

    es.each { |time, record|
      assert_equal 'hello', record['field1']
      assert_equal 'x\x9C\xCBH\xCD\xC9\xC9\a\x00\x06,\x02\x15', record['field3']
      assert_equal false, record.has_key?('field2')
    }
  end

end
