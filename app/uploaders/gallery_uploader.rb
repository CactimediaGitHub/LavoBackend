class GalleryUploader < CarrierWave::Uploader::Base
  include ::UploaderConcern

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :strip # strip image of all profiles and comments
  process :resize_to_fit => [480, 480]
  process :quality => 100 # Set JPEG/MIFF/PNG compression level (0-100)
  process :convert => 'jpg'
  process :colorspace => :rgb # Set colorspace to rgb or cmyk
  process :auto_orient # Rotate the image if it has orientation data

  # Create different versions of your uploaded files:
  version :thumb do
    process :strip # strip image of all profiles and comments
    process :resize_to_fit => [120, 120]
    process :quality => 100 # Set JPEG/MIFF/PNG compression level (0-100)
    process :convert => 'jpg'
    process :colorspace => :rgb # Set colorspace to rgb or cmyk
    process :auto_orient # Rotate the image if it has orientation data
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   see UploaderConcern
  # end

  def filename
    @filename = "#{secure_token}_#{split_extension(original_filename)}.#{file.extension}" if original_filename.present?
  end

  def split_extension(filename)
      extension_matchers = [
        /\A(.+)\.(tar\.([glx]?z|bz2))\z/, # matches "something.tar.gz"
        /\A(.+)\.([^\.]+)\z/ # matches "something.jpg"
      ]

      extension_matchers.each do |regexp|
        if filename =~ regexp
          return $1
        end
      end
      return filename, "" # In case we weren't able to split the extension
    end
end
