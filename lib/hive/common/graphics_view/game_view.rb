require 'rubygems' # only necessary in Ruby 1.8
require 'gosu'
require 'chingu'
require 'graphics_view/hexagon_piece'
require 'graphics_view/view_constants'
require 'game'
require 'boardstate'

#TODO's
#
# board scaling
# player UI
# sounds

class Hive::GameView < Chingu::Window
attr_reader :zoom_factor 
attr_reader :piece_spacing 

  def initialize(game)
    super(Hive::ViewConstants::WINDOW_WIDTH, Hive::ViewConstants::WINDOW_HEIGHT, false)
    self.caption = 'Hive Boardgame view'
    
    #TODO retrieve absolute gem path 
    #@background = Gosu::Image.new(self, "../lib/hive/common/graphics_view/data/images/wood.jpg",true)
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @view_turn = 0
    @game = game
    @zoom_factor = 1.2
    @piece_spacing = 3.0
    @pieces = []
    Hive::Piece::PIECE_RANGE.each {|i| @pieces << Hive::HexagonPiece.new(self, i) }
end

def update
	@pieces.each_index do |i| 
		piece = @game.get_piece( i )
		if piece.used?
			x, y = index_to_screen_coordinates(piece.x, piece.y) 
		else
			x, y = stack_location(piece)	
		end
		@pieces[i].update x, y, piece
	end
end

def draw
	draw_background
	draw_grid
	@pieces.each { |pg| pg.draw } 
	@font.draw("#{ @game.get_state_description }", 10, 10, 12, 1.0, 1.0, -1)
end

def draw_grid
	i = 0
	@game.board_state.each_board_position do |xi,yi,zi,value|
	 	if zi==0
			unless value == Hive::Slot::UNCONNECTED
			  x, y = index_to_screen_coordinates(xi, yi) 
  			color = Gosu::Color.new(255, 255, 0, 255)
			  Hive::HexagonPiece.draw_hexagon(self,x,y, Hive::HexagonPiece::ENCLOSING_RADIUS * zoom_factor, color)
			  @font.draw("(#{xi},#{yi})", x-15, y-10, 12, 1.0, 1.0, -1) #if value.is_hive_piece_id?
		    #@font.draw("(#{value})", x-15, y + 10, 8, 1.0, 1.0, -1) if value <= Hive::Slot::UNCONNECTED
		  end 
		end
	end
end

 def draw_background
    draw_quad(
     0,     0,      Hive::ViewConstants::TOP_COLOR,
     Hive::ViewConstants::WINDOW_WIDTH, 0,      Hive::ViewConstants::TOP_COLOR,
     0,     Hive::ViewConstants::WINDOW_HEIGHT, Hive::ViewConstants::BOTTOM_COLOR,
     Hive::ViewConstants::WINDOW_WIDTH, Hive::ViewConstants::WINDOW_HEIGHT, Hive::ViewConstants::BOTTOM_COLOR,
     0)
 end

#TODO add zoom 
def index_to_screen_coordinates(xi, yi)  
    r = Hive::HexagonPiece::R
    h = Hive::HexagonPiece::H 
    s = Hive::HexagonPiece::S 
    x_pixel = ( (xi * (2 * r) + (yi & 1) * r) + @piece_spacing) * zoom_factor
    y_pixel = ( (yi * (h + s)) + @piece_spacing) * zoom_factor
    x_pixel += -(Hive::BoardState::BOARD_SIZE/2) * (Hive::HexagonPiece::ENCLOSING_RADIUS * zoom_factor) 
	  y_pixel += -(Hive::BoardState::BOARD_SIZE/2) * (Hive::HexagonPiece::ENCLOSING_RADIUS * zoom_factor)
	  
	  y_pixel -= 200
	   x_pixel -= 100
    
    return x_pixel, y_pixel     			   
end

def stack_location(piece)
	if piece.color == Hive::PieceColor::WHITE
		x, y = 70, 100 + (piece.id % Hive::Piece.num_play_pieces) * 30
	else
		x, y = Hive::ViewConstants::WINDOW_WIDTH - 70, 100 + (piece.id % Hive::Piece.num_play_pieces) * 30
	end
	return x , y
end

def self.open_view(game)
	window = Hive::GameView.new(game)
	window.show
end




end

