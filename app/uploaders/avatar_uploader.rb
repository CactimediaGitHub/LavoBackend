class AvatarUploader < CarrierWave::Uploader::Base
  include ::UploaderConcern

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # def default_url
  #   default_image_path =
  #   case
  #   when vendor?
  #     'fallback/vendor/default_vendor_avatar.jpg'
  #   when customer?
  #     'fallback/customer/default_customer_avatar.png'
  #   else
  #     'fallback/customer/default_customer_avatar.png'
  #   end
  #   ActionController::Base.helpers.asset_path(default_image_path)
  # end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:

  # process :strip # strip image of all profiles and comments
  # process :resize_to_limit => [420, 420], :if => :vendor?
  # process :resize_to_limit => [150, 150], :if => :customer?
  # process :quality => 100 # Set JPEG/MIFF/PNG compression level (0-100)
  # process :convert => 'jpg'
  # process :colorspace => :rgb # Set colorspace to rgb or cmyk
  # process :auto_orient # Rotate the image if it has orientation data

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end
  protected

  def vendor?(file=nil)
    model.class.name == "Vendor"
  end

  def customer?(file=nil)
    model.class.name == "Customer"
  end
end
