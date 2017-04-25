require 'ruby_parser'

# Monkey patch to support Ruby 2.4
RubyParser.class_eval do
  def self.for_current_ruby
    Ruby23Parser.new
  end
end