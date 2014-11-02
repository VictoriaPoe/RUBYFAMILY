class CommentsController < ApplicationController

  commentable = Micropost.create
  comment = commentable.comments.create
  comment.title = "First comment."
  comment.comment = "This is the first comment."
  comment.save

end
