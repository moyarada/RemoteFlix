class MoviesController < ApplicationController
  
  # GET /movies
  def index
    
    @movies = Movie.scoped(:order => :DateModified.desc)
    
    if (params[:since])
      @movies.scoped(:conditions => {:FirstReleasedYear.gt => params[:since].to_i-1})
    end
    
    if (params[:res] && params[:page])
      @movies.scoped(:paginate => {:per_page => params[:res], :page => params[:page]})
    end   
    
    @movies = @movies.all
    #if (params[:res] && params[:page] && params[:since]) 
    #  @movies = Movie.where(:FirstReleasedYear.gt => params[:since].to_i-1).sort(:DateModified.desc).paginate(:per_page => params[:res], :page => params[:page])
    #  @total_results = Movie.where(:FirstReleasedYear.gt => params[:since].to_i-1).count
    #elsif (params[:res] && params[:page])
    #  @movies = Movie.sort(:DateModified.desc).paginate(:per_page => params[:res], :page => params[:page])
    #  @total_results = Movie.count
    #elsif (params[:since]) # Too slow request
    #  @movies = Movie.where(:FirstReleasedYear.gt => params[:since].to_i-1).sort(:DateModified.desc)
    #  @total_results = Movie.where(:FirstReleasedYear.gt => params[:since].to_i-1).count
    #else # default request    
    #  @year_now = Time.new.year
    #  @movies = Movie.limit(30).offset(0).where(:FirstReleasedYear.gt => @year_now-1).sort(:DateModified.desc).order.all
    #  @total_results = Movie.where(:FirstReleasedYear.gt => @year_now).count
    #end  
    
    #@page = (@total_results / params[:res].to_i) - (@total_results / (params[:res].to_i)) - params[:offset].to_i +1;
    
    respond_to do |format|
      format.html
      format.json {render :json => {:page_size => params[:res], :page => params[:page], :total_records => @total_results.to_s, :data => @movies}}
    end
    
  end  
  
  # GET /movies/new
  def new
    
  end  
  
  # POST /movies
  def create
  end  
  
  # GET /movies/{id}
  def show
  end  
  
  # GET /movies/{id}/edit
  def edit 
  end  
  
  # PUT /movies/{id}
  def update
  end  
  
  # DELETE /movies/{id}
  def destroy
  end  
  
end
