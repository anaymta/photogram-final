class UsersController < ApplicationController
  #index
    def index
      render({:template => "users/index"})
    end 
end