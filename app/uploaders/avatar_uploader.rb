require 'carrierwave/processing/rmagick'
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :file

  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_limit => [200, 200]

  def content_type_whitelist
    /image\//
  end

end
