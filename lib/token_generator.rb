module TokenGenerator
  def self.uuid
    SecureRandom.uuid.gsub(/\-/,'')
  end

  def self.password
    SecureRandom.base64(6)[0..5]
  end
end