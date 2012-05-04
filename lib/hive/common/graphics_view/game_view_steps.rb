class Hive::GameStepView < Hive::GameView 
  
attr_reader  :next
attr_reader  :previous
attr_reader  :skipForward 
attr_reader  :skipBackward
  
  def initialize( moves )
    super()
    self.caption = 'Hive Boardgame view'
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    
    @next = Gosu::Image.new(self, GameStepView.BASE_RESOURCE_PATH + "/forward.png",true)
    @previous = Gosu::Image.new(self, GameStepView.BASE_RESOURCE_PATH + "/previous.png",true)
    @skipForward = Gosu::Image.new(self, GameStepView.BASE_RESOURCE_PATH + "/fast_forward.png",true)
    @skipBackward = Gosu::Image.new(self, GameStepView.BASE_RESOURCE_PATH + "/fast_back.png",true)
    
    #@zoom_factor = 0.7
    #@piece_spacing = 3.0
    #@pieces = hexagon_pieces    
  end
  
  def load_game( file_name )
    
  end
  
  def update
  	# @pieces.each_index do |i| 
  	#      piece = @game.get_piece( i )
  	#      if piece.used?
  	#        x, y = index_to_screen_coordinates(piece.x, piece.y) 
  	#      else
  	#        x, y = stack_location(piece)  
  	#      end
  	#      @pieces[i].update x, y, piece
  	#    end
  end

  def draw
  	draw_background
  	#    draw_grid
  	#    @pieces.each { |pg| pg.draw } 
  	#    @font.draw("#{ @game.get_state_description }", 10, 10, 12, 1.0, 1.0, -1)
  end
  
  def draw_background
     draw_quad(
      0,     0,      Hive::ViewConstants::TOP_COLOR,
      Hive::ViewConstants::WINDOW_WIDTH, 0,      Hive::ViewConstants::TOP_COLOR,
      0,     Hive::ViewConstants::WINDOW_HEIGHT, Hive::ViewConstants::BOTTOM_COLOR,
      Hive::ViewConstants::WINDOW_WIDTH, Hive::ViewConstants::WINDOW_HEIGHT, Hive::ViewConstants::BOTTOM_COLOR,
      0)
  end
  

  def draw_grid
    # i = 0
    #     @game.board_state.each_board_position do |xi,yi,zi,value|
    #       if zi==0
    #         unless value == Hive::Slot::UNCONNECTED
    #           x, y = index_to_screen_coordinates(xi, yi) 
    #           color = Gosu::Color.new(255, 255, 0, 255)
    #           Hive::HexagonPiece.draw_hexagon(self,x,y, Hive::HexagonPiece::ENCLOSING_RADIUS * zoom_factor, color)
    #           @font.draw("(#{xi},#{yi})", x-15, y-10, 12, 1.0, 1.0, -1) #if value.is_hive_piece_id?
    #           #@font.draw("(#{value})", x-15, y + 10, 8, 1.0, 1.0, -1) if value <= Hive::Slot::UNCONNECTED
    #         end 
    #       end
    #     end
  end
  
  
  
  
end