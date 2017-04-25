require 'active_support/concern'

module ImagesManagement
  extend ActiveSupport::Concern

  def add_images(uploaded_files=[])
    files = self.images.map(&:file)
    files += uploaded_files
    self.images = files
  end

  def remove_images_by(index)
    remain_files = self.images
    remain_files.delete_at(index)

    #NOTE: #remove_images! - Carrierwave method
    remain_files.empty? ? self.remove_images! : self.images = remain_files
  end
end
