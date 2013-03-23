class StudiesController < ApplicationController
  # caches_page :show

  # GET /library?search=keyword
  # GET /library.json
  def index
    @studies = (
      if params[:search]
        Study.search do
          fulltext params[:search]
        end
        
      else # Not searching
        Study.all
      end
    )
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @studies }
    end
  end

  # GET /library/1
  # GET /library/1.json
  def show
    @study = Study.find(params[:id])
    
    
      
    respond_to do |format|  
      # Follow old friendly_id 
      unless request.path == study_path(@study)
        redirect_to( @study, status: :moved_permanently ) && return
      end
      
      format.html # show.html.erb
      format.json { render json: @study }
    end
  end

end
