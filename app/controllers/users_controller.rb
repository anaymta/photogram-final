class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })
  #index
    def index
      matching_users = User.all

      @list_of_users = matching_users.order({ :username => :desc })

      render({:template => "users/index"})
    end 

    def edit
      render({:template => "devise/registration/edit"})
    end

    def current_user_permission?(user)
      @this_user = User.where(:username => params.fetch("username")).first
      return true if current_user.id == @this_user.id
      return true if @this_user.private == false
      return true if @this_user.private == true && current_user.follow_sent.where(:status => "accepted", :recipient_id => @this_user.id).present?
    end

    def profile
      @this_user = User.where(:username => params.fetch("username")).first
      if current_user_permission?(@this_user)
        render({:template => "users/profile"})
      else
          redirect_to("/users", {:notice => "You are do not have permission to view these details." })
      end
    end 

    def liked_photos
      @this_user = User.where(:username => params.fetch("username")).first

      @likes_sent = Like.where(:fan_id => @this_user.id)

      render({:template => "users/liked_photos"})
    end 

    def feed
      @this_user = User.where(:username => params.fetch("username")).first
      @all_following = @this_user.follow_sent.where(:status => "accepted").pluck(:recipient_id)
      @all_following_photos = Photo.where(owner_id: @all_following)

      render({:template => "users/feed"})
    end

    def discover
      @this_user = User.where(:username => params.fetch("username")).first
      @all_following = User.where(id: @this_user.follow_sent.where(:status => "accepted").pluck(:recipient_id))
      @all_following_likes = Like.where(fan_id: @all_following.pluck(:id))
      @all_following_liked_photos = Photo.where(id: @all_following_likes.pluck(:photo_id))

      render({:template => "users/discover"})
    end 

end
