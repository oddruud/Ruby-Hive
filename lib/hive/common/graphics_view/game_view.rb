require 'gosu'
require 'chingu'
require 'graphics_view/interface'

class Hive::GameView < Chingu::Window

  @@BASE_RESOURCE_PATH = "../resources"
  attr_reader :interface
  
  def initialize()
    super(Hive::ViewConstants::WINDOW_WIDTH, Hive::ViewConstants::WINDOW_HEIGHT, false)
    @interface = Hive::Interface.new() 
  end
  
end