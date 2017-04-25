class API::V1::Support::Encoder
  def self.urlsave_dump(obj)
    Base64.urlsafe_encode64(Marshal.dump(obj), padding: false)
  end

  def self.urlsave_load(str)
    Marshal.load(Base64.urlsafe_decode64(str))
  end
end