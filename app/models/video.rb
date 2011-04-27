
class Video
  include MongoMapper::Document
  
  key :url, String, :unique => true  
  key :Type, String
  key :duration, Integer
  key :medium, String
  key :StreamingFlavorId, Integer
  key :Bitrate, Integer
  
  belongs_to :movie
end  

Video.ensure_index :url, :unique => true