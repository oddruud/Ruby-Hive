require 'rubygems' # only necessary in Ruby 1.8
require 'gosu'
require 'GraphicsView/viewconstants'


class Hive::HexagonPiece

ENCLOSING_RADIUS = 50 
R = (Math.sin(Math::PI/3.0) * ENCLOSING_RADIUS)
H = Math.cos(Math::PI/3.0) * R
S = ENCLOSING_RADIUS * 2 - H * 2 


@@piece_image_names = Array.new() 
@@piece_image_names<< "anim.jpg"# "WHITE_QUEEN_BEE.jpg"
@@piece_image_names << "anim.jpg"#"WHITE_BEETLE1.jpg"
@@piece_image_names << "anim.jpg"#"WHITE_BEETLE2.jpg"
@@piece_image_names << "anim.jpg"#"WHITE_SPIDER1.jpg" 
@@piece_image_names << "anim.jpg"#"WHITE_SPIDER2.jpg"
@@piece_image_names << "anim.jpg"#"WHITE_GRASSHOPPER1.jpg" 
@@piece_image_names << "anim.jpg"#"WHITE_GRASSHOPPER2.jpg" 
@@piece_image_names << "anim.jpg"#"WHITE_GRASSHOPPER3.jpg" 
@@piece_image_names << "anim.jpg"#"WHITE_ANT1.jpg"  
@@piece_image_names << "anim.jpg"#"WHITE_ANT2.jpg"  
@@piece_image_names << "anim.jpg"#"WHITE_ANT3.jpg" 
@@piece_image_names << "anim.jpg"#"WHITE_MOSQUITO.jpg" 
@@piece_image_names << "anim.jpg"#"BLACK_QUEEN_BEE.jpg"
@@piece_image_names << "anim.jpg"#"BLACK_BEETLE1.jpg" 
@@piece_image_names << "anim.jpg"#"BLACK_BEETLE2.jpg"
@@piece_image_names << "anim.jpg"#"BLACK_SPIDER1.jpg"
@@piece_image_names << "anim.jpg"#"BLACK_SPIDER2.jpg"
@@piece_image_names << "anim.jpg"#"BLACK_GRASSHOPPER1.jpg" 
@@piece_image_names << "anim.jpg"#"BLACK_GRASSHOPPER2.jpg"
@@piece_image_names << "anim.jpg"#"BLACK_GRASSHOPPER3.jpg"
@@piece_image_names << "anim.jpg"#"BLACK_ANT1.jpg"
@@piece_image_names << "anim.jpg"#"BLACK_ANT2.jpg"
@@piece_image_names << "anim.jpg"#"BLACK_ANT3.jpg"
@@piece_image_names << "anim.jpg"#"BLACK_MOSQUITO.jpg"



def initialize(window, id)
 @id  = id
 image_name = @@piece_image_names[id]
 @image = Gosu::Image.new(window, "hive/Common/GraphicsView/Data/images/#{image_name}",true) 
 @x,@y,@z = 0.0, 0.0, 0
 @used = false
 @window = window
 @movable = true
 @name = "-"
 @font = Gosu::Font.new(window, Gosu::default_font_name, 12)
 @color = Hive::PieceColor::WHITE
end

def update(x,y, piece)
	@x = x  
	@y = y
	@z = piece.z
	@z ||= 0
	@used = piece.used
	@movable = piece.movable?
	@name = piece.name
	@color = piece.color
end

def draw 
	if @color == Hive::PieceColor::WHITE
		color = Gosu::Color.new(255, 255, 255, 255)
	else
		color = Gosu::Color.new(255, 0, 0, 0)
	end
	draw_lock_state unless @movable
	
	Hive::HexagonPiece.draw_hexagon(@window, @x, @y, ENCLOSING_RADIUS - (@z * 10), color)
	
	@font.draw("#{@name}", @x-40, @y+20 - (@z * 10), 5, 1.0, 1.0, -1)
end

def self.draw_hexagon window, x, y, radius ,color
	(1..6).each do |i|
		angle1 = (Math::PI/3.0) * (i-1) + (Math::PI/6.0) 
		angle2 = (Math::PI/3.0) * i + (Math::PI/6.0)
		x1 = x + Math.cos(angle1) * radius 
		y1 = y + Math.sin(angle1) * radius
		x2 = x + Math.cos(angle2) * radius
		y2 = y + Math.sin(angle2) * radius
		window.draw_line(x1, y1, color, x2, y2, color, 4)
	end
end 


def draw_lock_state
	lock_color =  Gosu::Color.new(0, 0, 255, 255)
	 @window.draw_quad(
     @x - ENCLOSING_RADIUS/4,     @y - ENCLOSING_RADIUS/4,     lock_color,
     @x + ENCLOSING_RADIUS/4, @y - ENCLOSING_RADIUS/4,    lock_color,
     @x - ENCLOSING_RADIUS/4, @y + ENCLOSING_RADIUS/4, lock_color,
     @x + ENCLOSING_RADIUS/4, @y + ENCLOSING_RADIUS/4, lock_color,
     0)
end


end
