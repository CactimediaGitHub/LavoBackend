require 'active_support/concern'

module UploaderConcern
  extend ActiveSupport::Concern

  included do
    include CarrierWave::MiniMagick
    include CarrierWave::Processing::MiniMagick
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   @filename_uuid ||= TokenGenerator.uuid
  #   "#{@filename_uuid}.#{file.extension}" if original_filename.present?
  # end

  #NOTE: https://github.com/carrierwaveuploader/carrierwave/wiki/how-to:-create-random-and-unique-filenames-for-all-versioned-files
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, TokenGenerator.uuid)
  end

end
