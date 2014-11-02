class Comments < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  acts_as_commentable :public, :private
  commentable = Micropost.create
  comment = commentable.comments.create
  comment.title = "First comment."
  comment.comment = "This is the first comment."
  comment.save
  acts_as_commentable :public, :private, { class_name: 'MyComment' }

end
public_comments = Todo.find(1).public_comments
private_comments = Todo.find(1).private_comments



  acts_as_commentable :public, :private, { class_name: 'MyComment' }

