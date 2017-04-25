class API::V1::Support::ConvertToCents; end

API::V1::Support::ConvertToCents.class_eval do
  attr_accessor :params, :parent_key, :child_key, :cents

  def initialize(args={})
    @params = args[:params]
    @parent_key = args[:parent_key]
    @child_key = args[:child_key]
  end

  def cents
    @cents ||= (params[parent_key][child_key].to_d * 100).to_i
  rescue
    raise 'Parent key or child key need to be set'
  end

  def convert
    params[parent_key][child_key] = cents
    params
  end
end
