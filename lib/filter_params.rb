# frozen_string_literal: true
module FilterParams
  def self.filtered_fields(filters, allowed, transform)
    return {} if filters.nil?

    # NOTE: unused fix
    # if filters.is_a?(String)
    #   filters = filters.split('&').map {|f| f.split('=')}.to_h
    # end

    filtered = {}
    filters.each do |key, value|
      # Underscore the field (JSONAPI attributes are dasherized)
      key_sym = key.underscore.to_sym
      if allowed.include?(key_sym)
        filtered[key_sym] = format_value(value, transform[key_sym])
      end
    end
    filtered
  end

  def self.format_value(value, type)
    case type
    when :time_range
      format_time_range(value)
    when :human_time_range
      format_human_time_range(value)
    when :date_range
      format_date_range(value)
    else
      value
    end
  end

  def self.format_time_range(value)
    date_parts = value.split('..')
    start = date_parts.first.to_time
    finish = date_parts.last.to_time
    start..finish
  rescue ArgumentError, 'invalid time' => _e
    nil
  end

  def self.format_human_time_range(value)
    start, finish =
      case value.to_sym
      when :yesterday
        [1.day.ago.beginning_of_day, 1.day.ago.end_of_day]
      when :today
        [Time.now.beginning_of_day, Time.now.end_of_day]
      when :tomorrow
        [1.day.from_now.beginning_of_day, 1.day.from_now.end_of_day]
      when :week
        [Time.now.beginning_of_week, Time.now.end_of_week]
      when :month
        [Time.now.beginning_of_month, Time.now.end_of_month]
      when :quarter
        [Time.now.beginning_of_quarter, Time.now.end_of_quarter]
      else
        raise ArgumentError
      end
    start..finish
  rescue ArgumentError, 'invalid human time' => _e
    nil
  end

  def self.format_date_range(value)
    date_parts = value.split('..')
    start = date_parts.first.to_date
    finish = date_parts.last.to_date
    start..finish
  rescue ArgumentError, 'invalid date' => _e
    nil
  end
end