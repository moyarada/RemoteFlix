# utils/data.rb
require 'xml'
require 'net/http'
require 'uri'

class DataApi
  def initialize(params={})
    @dev_id = "715b55b1-5c43-4e5b-a23f-286a4b863a92"
    @base_url = "http://api.internetvideoarchive.com/Video/"
    #@categories = Hash(
    #  0, "PublishedId (default)",
    #  6, "ROVI Program ID",
    #  7, "All Movie Guide Movie ID",
    #  9, "Cinema Source ID",
    #  11, "Tribune Media Services (TMS)",
    #  12, "IMDB",
    #  13, "Amazon (ASIN)",
    #  14, "Muze Movie",
    #  15, "UPC",
    #  17, "iTunes",
    #  19, "ISBN",
    #  20, "EAN (coming soon)",
    #  21, "Nielsen Film code",
    #  22, "Nielsen US Release Code",
    #  23, "Flixster",
    #  24, "Gracenote (Movie)",
    #  38, "Baseline",
    #  39, "Netflix"
    #)
    
    #@genres = Hash(
   # -1,	"Not Assigned",
   # 0,	"Western",
   # 1,	"Action-Adventure",
   # 2,	"Children's",
   # 3,	"Comedy",
   # 4,	"Drama",
   # 5,	"Family",
   # 6,	"Horror",
   # 7,	"Musical",
   # 8,	"Mystery-Suspense",
   # 9,	"Non-Fiction",
   # 10,	"Sci-Fi",
   # 11,	"War",
   # 12,	"Health/ Workout",
   # 13,	"Documentary",
   # 14,	"Thriller",
  #  15,	"Biography",
   # 16,	"Romance")
    
    @search_term_param = "SearchTerm="
    @dev_id_param = "DeveloperId=#{@dev_id}"
    @output_format_param = "OutputFormat=0" # 1 - IVA Standard XML, 2 Media RSS Ext, 3. Media RSS
    @random_param = "Randomize="
    @page_param = "Page="
    @page_size_param = "PageSize="
    @include_all_assets_param = "IncludeAllAssets="
    @flash_only_param = "FlashOnly="
    @sort_by_param = "SortBy="
    @idtype_param = "IDType="
    @pidtype_param = "PIDType="
    @content_network_param = "ContentNetwork=3,4,5" # 3- YouTube, 4 - BrightCove Sony, 5 - BrightCove Warner
    @offset_param = "Page="
    @limit_param = "PageSize="
  end
  
  def movies_by_title(title, offset = 1, limit = 20)
    url = "#{@base_url}TitleSearch.aspx"
    puts "Start with #{url}"
    videos = get_movies_for_url(url, title, offset, limit)
  end
  
  def movies_since_date(date, offset = 1, limit = 20)
    url = "#{@base_url}MoviesSinceDate.aspx"
    puts "Start with #{url}"
    videos = get_movies_for_url(url, date, offset, limit)
  end
  
  def get_movies_for_url(baseurl, searchTerm, offset, limit)
    
    url = "#{baseurl}?#{@dev_id_param}&#{@search_term_param}#{CGI.escape(searchTerm)}&#{@offset_param}#{offset}&#{@limit_param}#{limit}&#{@output_format_param}"
    videos = []
    meta = get_meta(url)
    
    @total_records = meta['TotalRecordCount']
    @page_count = meta['PageCount']
    @cur_page = meta['Page']
    @page_size = meta['PageSize']
    
    puts "Meta: #{@total_records} #{@page_count} #{@page_size}"
    
    0.upto(@page_count.to_i-1) { |i|
      url = "#{baseurl}?#{@dev_id_param}&#{@search_term_param}#{CGI.escape(searchTerm)}&#{@offset_param}#{i+offset}&#{@limit_param}#{limit}&#{@output_format_param}"
      puts "Fetching #{url}"
      xml = get_url(url)
      #puts xml
      parser = XML::Parser.string(xml)
      doc = parser.parse
      videos << store_videos(doc)
      puts "Done with #{videos.count}"
      if (i != 1)
        #sleep 1.0
      end
    }
    
    videos
    
  end  
  
  def get_meta(url)
    xml = get_url(url)
    parser = XML::Parser.string(xml)
    doc = parser.parse
    meta = {}
    doc.find("/items").each do |node|
      node.attributes.each do |atr|
        meta[atr.name] = atr.value
      end  
    end  
    
    meta
  end  
  
  def store_videos(doc) 
    videos = []
    doc.find('//items/item').each do |s|
      h = {} # Array of items
      %w[Description Title Language Country SiteUrl Studio StudioID Rating Genre GenreID Warning HomeVideoReleaseDate TheatricalReleaseDate Director DirectorID Actor1 ActorId1 Actor2 ActorId2
        Actor3 ActorId3 Actor4 ActorId4 Actor5 ActorId5 Actor6 ActorId6
        Link BoxOfficeInMillions AirDayOfWeek IsTelevisionContent FirstReleasedYear Image Duration DateCreated Media PublishedId DateModified EmbedUrl ExpirationDate IsHdSource
        videos ParentPublishedID ContentNetworks relatedvideos].each do |a|
        
        if (s.find(a).first) 
          h[a.intern] = s.find(a).first.content
        end
        
        
        if (s.find(a).length > 0 && (a == 'videos' || a == 'relatedvideos'))
          
          s.find(a).each { |node| #for each videos node
            #if (!node.empty?)
            #puts "Videos #{node.inspect}"
            links = [] # video links array
            node.each { |vid| # for each video node
              item = {} # video node attributes hash
              vid.attributes.each { |nod| # for each video node attribute
                item[nod.name] = nod.value 
              }
              if (!item.empty?)
                links.push(item) # add video node attrs to links array  
              end
            }
            h[a.intern] = links
          }
        end
         
      end
      
      videos << h
    end
    #puts videos[0].inspect
    
    videos.each {|movie|
      #puts vid[:PublishedId]
      isThere = Movie.where(:PublishedId => movie[:PublishedId]).count
      puts isThere
      if (isThere == 0) 
        puts "Adding Video #{movie[:PublishedId]}"
        movie = Movie.new(movie)
        movie.save!
      else
        puts "Video #{movie[:PublishedId]} has been already added"
      end
    }
    
   
    videos # return
  end  
  
  def movies_since(date)
    url = "#{@base_url}MoviesSinceDate.aspx?#{dev_id_param}&#{search_term_param}#{date}"
    xml = File.read(url)
    
  end
  
  # Return Content of URL
  def get_url(url)
    myurl = URI.parse(url)
    req = Net::HTTP::Get.new(url)
    res = Net::HTTP.start(myurl.host, myurl.port) { |http|
      http.request(req)
    }
    
    res.body # return
  end
  
end


