class CinemagraphController < ApplicationController
  
  def index
    @cinemagraphs = ['cinemagraph1', 'cinemagraph2']
  end

end