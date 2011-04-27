class Movie
  include MongoMapper::Document
  include Scopify
  
  key :PublishedId, String, :unique => true  
  key :IsHdSource, Boolean
  key :BoxOfficeInMillions, String
  key :Rating, String
  key :Country, String
  key :Media, String
  key :Director, String
  key :Title, String
  key :ParentPublishedID, String
  key :AirDayOfWeek, String
  key :Genre, String
  key :DirectorID, Integer
  key :Language, String
  key :ContentNetworks, String
  key :IsTelevisionContent, Boolean
  key :GenreID, String
  key :DateModified, Time
  key :DateCreated, Time
  key :Actor1, String
  key :ActorId1, String
  key :SiteUrl, String
  key :FirstReleasedYear, Integer
  key :Warning, String
  key :EmbedUrl, String
  key :Studio, String
  key :ExpirationDate, Time
  #key :videos, Array, :typecast => 'Movie'
  key :relatedvideos, Array
  
  many :videos
end  

Movie.ensure_index :PublishedId, :unique => true
Movie.ensure_index :FirstReleasedYear
Movie.ensure_index :DateModified
Movie.ensure_index :GenreID