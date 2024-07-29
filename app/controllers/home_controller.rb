class HomeController < ApplicationController
  def index

  end

  def about
    @about_me = "My first RubyOnRails project...!"
  end
end
