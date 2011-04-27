class FrontPagesController < ApplicationController
  
  def index
    @videos = Movie.where(:FirstReleasedYear.gt => 2010).sort(:DateModified.desc).limit(30)
    respond_to do |format|
      format.html
      format.json {render :json => @videos}
    end  
  end  
  
  def show
    if (params[:title]) 
      @data_api = DataApi.new
      #@videos = @data_api.movies_by_title(params[:title], 1, 50)
      @videos = @data_api.movies_since_date(params[:title], 71, 50)
    end
    
    @vis = Movie.all
    
    respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @vis }
          format.json  { render :json => @vis }
    end
    
  end
end
