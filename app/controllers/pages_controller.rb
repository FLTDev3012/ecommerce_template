class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :font ]

  def home
  end

  def font
  end

end
