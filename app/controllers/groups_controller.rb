class GroupsController < ApplicationController
  before_filter :authenticate_user!, except:[:index, :show]
  before_filter :safe_select_group, except:[:new, :create]
  
  # GET /groups
  # GET /groups.json
  def index
    if user_signed_in?
      template= 'index.html.erb'
    else
      @groups = Group.publicly_searchable.all
      template= 'public_index.html.erb'
    end

    respond_to do |format|
      format.html template:template 
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    if user_signed_in?
      template= 'show.html.erb'
    else
      @group = Group.publicly_searchable.all
      template= 'public_show.html.erb'
    end
    respond_to do |format|
      format.html template:template 
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end
  
private
  
  # scopes SELECT to current user
  def safe_select_group
    return unless user_signed_in?
    @groups = current_user.groups
    @group = @groups.where(id:params[:id])
  end
end
