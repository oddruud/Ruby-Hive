require 'rubygems' # only necessary in Ruby 1.8
require 'gosu'
require 'chingu'
require 'GraphicsView/hexagonpiece'
require 'gamehandler'
require 'boardstate'
require 'GraphicsView/viewconstants'

#TODO's
#
# board scaling
# player UI
# sounds

class GameView < Chingu::Window

  def initialize(gamehandler)
    super(ViewConstants::WINDOW_WIDTH, ViewConstants::WINDOW_HEIGHT, false)
    self.caption = 'Hive Boardgame view'
    @background = Gosu::Image.new(self, "Common/GraphicsView/Data/images/wood.jpg",true)
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @view_turn = 0
    @gamehandler = gamehandler
    @pieces = Array.new()
    (0..23).each {|i| @pieces << HexagonPiece.new(self, i) }
end

def update
	@pieces.each_index do |i| 
		piece = @gamehandler.getPiece(i, @view_turn)
		if piece.used
			x, y = indexToPixelCoordinates(piece.x, piece.y) 
		else
			x, y = stackLocation(piece.id)	
		end
		@pieces[i].update x, y, piece
	end
end

def draw 
	@background.draw(ViewConstants::WINDOW_WIDTH / 2 - 500, ViewConstants::WINDOW_HEIGHT / 2 - 375, 0)
	drawGrid
	@pieces.each { |pg| pg.draw } 
	@font.draw("#{ @gamehandler.getStateDescription }", 10, 10, 12, 1.0, 1.0, -1)
end

def drawGrid
	i = 0
	@gamehandler.board_state.eachBoardPosition do |xi,yi,zi,value|
	 	if zi==0
			x, y = indexToPixelCoordinates(xi, yi) 
			color = Gosu::Color.new(255, 0, 0, 255)
			HexagonPiece.drawHexagon(self,x,y, HexagonPiece::ENCLOSING_RADIUS, color)
			@font.draw("(#{xi},#{yi})", x-15, y-10, 12, 1.0, 1.0, -1)
		  @font.draw("(#{value})", x-15, y + 10, 8, 1.0, 1.0, -1) if value <= Slot::UNCONNECTED 
		end
	end
end

def indexToPixelCoordinates(xi, yi)  
    r = HexagonPiece::R
    h = HexagonPiece::H 
    s = HexagonPiece::S 
    x_pixel = xi * (2 * r) + (yi & 1) * r
    y_pixel = yi * (h + s)  
    x_pixel += ViewConstants::WINDOW_WIDTH / 2 - 5 * ( r * 2 )
	y_pixel += 100
    return x_pixel, y_pixel     			   
end

def stackLocation(piece_id)
	if piece_id < 12
		x, y = 70, 100+(piece_id % 12) * 30
	else
		x, y = ViewConstants::WINDOW_WIDTH - 70, 100+(piece_id % 12) * 30
	end
	return x , y
end




end

