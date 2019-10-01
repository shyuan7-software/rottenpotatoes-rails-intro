class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings=Movie.all_ratings
    @check_ratings = params[:ratings]
    @original_check_ratings = params[:ratings]
    @remembered_check_ratings = session[:ratings]
    if @check_ratings
      session[:ratings]=@check_ratings
      #@movies = Movie.with_ratings(@check_ratings)
    else
      if @remembered_check_ratings
        @check_ratings=@remembered_check_ratings
      else
        @check_ratings={'G' => true,'PG' => true, 'PG-13'=> true, 'R' => true}
        session[:ratings]=@check_ratings
      end
      #redirect_to :ratings => @check_ratings
    end
    
    @sort_method = params[:sort]
    @original_sort_method = params[:sort]
    @remembered_sort_method = session[:sort]
    if @sort_method
      session[:sort]=@sort_method
    else
      if @remembered_sort_method
        @sort_method=@remembered_sort_method
      else
        @sort_method =''
        session[:sort]=@sort_method
      end
      #redirect_to :sort => @sort_method
    end
    
    if @original_sort_method!=@sort_method||@original_check_ratings!=@check_ratings
      flash.keep
      redirect_to :sort => @sort_method, :ratings =>@check_ratings
    end
    
    if @sort_method=='title'
      @title_hilite = 'hilite'
      @release_date_hilite = ''
    elsif @sort_method=='release_date'
      @title_hilite = ''
      @release_date_hilite = 'hilite'
    else
      @title_hilite = ''
      @release_date_hilite = ''
    end
    @movies = Movie.with_ratings(@check_ratings).order(@sort_method)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
