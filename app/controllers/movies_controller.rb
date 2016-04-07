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
    session["sort"] = "" if not session["sort"]
    session["ratings"] = "" if not session["ratings"]
    session["sort"] = params[:sort] ? params[:sort] : session["sort"]
    session["ratings"] = params[:ratings] ? params[:ratings] : session["ratings"]
    @ratings = session[:ratings] == nil ? [] : session[:ratings]
    
    if session[:sort] == "title" or session[:sort] == "release_date"
      @movies = @ratings.empty? ? Movie.order("#{session[:sort]} ASC").all : Movie.order("#{session[:sort]} ASC").all.select{|p| @ratings.include? p.rating}
      session[:sort] == "title" ? @title_class = "hilite" : @date_class = "hilite"
    else
      @title_class, @date_class = "", ""
      @movies = @ratings.empty? ? Movie.all : Movie.all.select{|p| @ratings.include? p.rating}
    end

    @all_ratings = Movie.distinct.pluck(:rating)
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
