require 'gosu'
require 'chingu'

class Hive::GameView < Chingu::Window

  @@BASE_RESOURCE_PATH = "../resources"
  
  def initialize()
    super(Hive::ViewConstants::WINDOW_WIDTH, Hive::ViewConstants::WINDOW_HEIGHT, false)
  end
  
end