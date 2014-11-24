class CommentsController < ApplicationController
  # GET /microposts/:micropost_id/comments
  # GET /microposts/:micropost_id/comments.xml
  def index
    #1st you retrieve the micropost thanks to params[:micropost_id]
    micropost = Micropost.find(params[:post_id])
    #2nd you get all the comments of this post
    @comments = micropost.comments

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /microposts/:micropost_id/comments/:id
  # GET /comments/:id.xml
  def show
    #1st you retrieve the post thanks to params[:post_id]
    micropost = micropost.find(params[:post_id])
    #2nd you retrieve the comment thanks to params[:id]
    @comment = micropost.comments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /microposts/:micropost_id/comments/new
  # GET /microposts/:micropost_id/comments/new.xml
  def new
    #1st you retrieve the post thanks to params[:micropost_id]
    micropost = micropost.find(params[:micropost_id])
    #2nd you build a new one
    @comment = micropost.comments.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /posts/:post_id/comments/:id/edit
  def edit
    #1st you retrieve the post thanks to params[:post_id]
    micropost = micropost.find(params[:post_id])
    #2nd you retrieve the comment thanks to params[:id]
    @comment = micropost.comments.find(params[:id])
  end

  # POST /posts/:post_id/comments
  # POST /posts/:post_id/comments.xml
  def create
    #1st you retrieve the post thanks to params[:post_id]
    micropost = micropost.find(params[:micropost_id])
    #2nd you create the comment with arguments in params[:comment]
    @comment = micropost.comments.create(params[:comment])

    respond_to do |format|
      if @comment.save
        #1st argument of redirect_to is an array, in order to build the correct route to the nested resource comment
        format.html { redirect_to([@comment.micropost, @comment], :notice => 'Comment was successfully created.') }
        #the key :location is associated to an array in order to build the correct route to the nested resource comment
        format.xml  { render :xml => @comment, :status => :created, :location => [@comment.micropost, @comment] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/:post_id/comments/:id
  # PUT /posts/:post_id/comments/:id.xml
  def update
    #1st you retrieve the post thanks to params[:post_id]
    micropost = micropost.find(params[:micropost_id])
    #2nd you retrieve the comment thanks to params[:id]
    @comment = micropost.comments.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        #1st argument of redirect_to is an array, in order to build the correct route to the nested resource comment
        format.html { redirect_to([@comment.micropost, @comment], :notice => 'Comment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/:post_id/comments/1
  # DELETE /posts/:post_id/comments/1.xml
  def destroy
    #1st you retrieve the post thanks to params[:post_id]
    micropost = micropost.find(params[:micropost_id])
    #2nd you retrieve the comment thanks to params[:id]
    @comment = micropost.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      #1st argument reference the path /posts/:post_id/comments/
      format.html { redirect_to(micropost_comments_url) }
      format.xml  { head :ok }
    end
  end
end