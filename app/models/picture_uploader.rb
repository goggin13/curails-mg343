class PictureUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
  process :convert => 'png'
  
  version :standard do
    cloudinary_transformation :radius => 20,
                              :width => 200, 
                              :height => 300 
  end
  
  version :thumbnail do
    cloudinary_transformation :effect => "sepia", 
                              :width => 100, 
                              :height => 100, 
                              :crop => :thumb, 
                              :gravity => :face
  end

end
