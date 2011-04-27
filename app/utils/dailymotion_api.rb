class DailyMotionApi
  def initialize
    @api_key = "7907f2deb12e49ad69c8"
    @api_secret = "d91cc161df54825d27be0e124197ae97cb9187b7"
    @app_website = "http://remoteflix.tv"
    @base_url = "https://api.dailymotion.com/videos"
    @sort_param = "sort="
    @fields_param = "fields=id, title, tags, channel, description, url, tiny_url, created_time, modified_time, type, private, explicit, published, duration, owner, owner_screenname, owner_url, owner_avatar_small_url, 
      owner_avatar_medium_url, owner_avatar_large_url, thumbnail_url, thumbnail_small_url, thumbnail_medium_url, thumbnail_large_url, rating, ratings_total, views_total, views_last_hour, views_last_day, 
      views_last_week, views_last_month, comments_total, bookmarks_total, embed_html, embed_url, aspect_ratio"
    @dev_id_param = "client_id=#{@api_key}&client_secret=#{@api_secret}"
    @page_param = "page="
    @offset_param = "limit="
    @sort_param = "sort=" # recent, visited, visited-hour, visited-today, visited-week, visited-month, commented, commented-hour, commented-today, commented-week, commented-month, rated, rated-hour, rated-today, rated-week, 
                          # rated-month, discussed, discussed-hour, discussed-today, discussed-week, discussed-month, relevance, random
    @filters_param = "filters=" #featured, hd, official, creative, creative-official, buzz, buzz-premium
    @localize_param = "localization=detect"
    @search_term_param = "search="
    @tag_param = "tag="
  end  
  
  
end