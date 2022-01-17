require 'dxruby'

Window.width = 1240
WW = Window.width
Window.height = 600
WH = Window.height
ARY = []

class Box < Sprite
    attr_accessor :bx, :by
    def initialize(x, y)
        super
        self.image = Image.new(@bx = 99, @by = 20, C_WHITE)
    end
end

class Boxs < Array
    def initialize
        10.times do |y|
            12.times do |x|
                self << Box.new(@box_d_x = 20 + 100 * x, @box_d_y = 50 + 21 * y)
            end
        end
    end
end

class Bar < Sprite
    attr_accessor :bx, :by
    def initialize(x = 0, y = WH - 50)
        super
        self.image = Image.new(@bx = 100, @by = 15, C_BLUE)
    end
    def update
        self.x = Input.mouse_x - 40
    end
end

class Ball < Sprite
    attr_accessor :dx, :dy
    def initialize(x, y)
        super
        @dx = 0
        @dy = 0
        self.image = Image.new(10, 10).circle_fill(5,5,5,C_WHITE)
    end

    def start
        if @dx == 0 && @dy == 0
            @dx = (rand(2) * 2 - 1) * 3 if Input.mouse_down?(M_LBUTTON)
            @dy = (rand(2) * 2 - 1) * 3 if Input.mouse_down?(M_LBUTTON)
        end
    end

    def update(boxs, blocks, bar)
        self.x += @dx
        self.y += @dy
        hit = self.check(blocks).first
        hit2 = self.check(boxs).first
        self.speed_up(boxs, bar)
        if hit != nil
            self.x -= @dx
            self.y -= @dy
            if hit.x < self.x && self.x < hit.x + hit.bx
                @dy *= -1
            elsif hit.y < self.y && self.y < hit.y + hit.by
                @dx *= -1
            else
                @dx *= -1
                @dy *= -1
            end
            hit2.vanish if hit2 != nil
        end
        @dx *= -1 if 0 >= self.x || self.x >= WW - 10
        @dy *= -1 if 0 >= self.y

    end

    def speed_up(boxs, bar)
        ARY << self.check(boxs).first
        ARY.compact!
        if ARY.size == 3
            @dx < 0 ? self.dx -= 1 : self.dx += 1
            @dy < 0 ? self.dy -= 1 : self.dy += 1
            ARY.clear
        end
        ARY.clear if self === bar
    end
end
blocks = [boxs = Boxs.new, bar = Bar.new]
ball = Ball.new(200, 500)


Window.loop do
    Sprite.draw(blocks)
    ball.draw
    ball.start
    Sprite.update(blocks)
    ball.update(boxs, blocks, bar)

    break if Input.key_push?(K_ESCAPE)
end