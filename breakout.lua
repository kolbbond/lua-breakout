math.randomseed(os.time())

-- globals
xbound = 1; ybound = 1;

Rect = { x = 0, y = 0, width = 0.3, height = 0.3, red = 0.0, green = 1.0, blue = 0.0 }

function Rect:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Rect:draw()
    draw_rectangle(self.x, self.y, self.width, self.height, self.red, self.green, self.blue)
end

function Rect:intersects(other)
    if math.abs(self.x - other.x) < (self.width + other.width) / 2 and
        math.abs(self.y - other.y) < (self.height + other.height) / 2 then
        return true
    else
        return false
    end
end

---------------------------
--  block
Block = {};
function Block:new(o)
    o = o or {};
    setmetatable(o, self)
    self.__index = self
    o:init()
    return o
end

function Block:init()
    self.rect = Rect:new { width = 0.05, height = 0.3 }

    self.rect.x = 0;
    self.rect.y = 0.5;
    self.rect.red = 0.5
    self.rect.green = 0.0
    self.rect.blue = 1.0
end

function Block:draw()
    self.rect.y = self.y
    self.rect:draw()
end

---------------------------
-- paddle

Paddle = { x = 0, y = 0 }

function Paddle:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o:init()
    return o
end

function Paddle:init()
    self.rect = Rect:new { x = x, y = y, width = 0.3, height = 0.03 }

    -- position
    self.rect.x = 0.0
    self.rect.y = -1

    -- color
    self.rect.red = 1.0
    self.rect.green = 0.0
    self.rect.blue = 1.0
end

function Paddle:draw()
    self.rect.x = self.x
    self.rect.y = self.y
    self.rect:draw()
end

function Paddle:move()
    -- player
    -- check C move functions
    vp = 0.04;
    if left_pressed() then self.x = self.x - vp end
    if right_pressed() then self.x = self.x + vp end

    -- check paddle against bounds
    if self.x < -xbound then
        self.x = -xbound + 0.1
    end
    if self.x + self.rect.width / 2 > xbound then
        self.x = xbound - self.rect.width / 2 - 0.1
    end
end

---------------------------

Ball = { x = 0, y = 0.1, vx = 0.0, vy = 0.0 }

function Ball:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o:init()
    return o
end

function Ball:init()
    self.rect = Rect:new { x = x, y = y, width = 0.03, height = 0.03, red = 1.0, green = 0.0, blue = 0.0 }
end

function Ball:move()
    newrect = Rect:new(self.rect)
    newrect.x = newrect.x + self.vx
    newrect.y = newrect.y + self.vy

    -- check hit against paddle
    vb = 0.1; -- ball acceleration
    if paddle.rect:intersects(newrect) then
        self.vx = self.vx * (-1.0 + vb)
        self.vy = self.vy * (-1.0 + vb)
    end

    -- check hit against blocks
    --[[
    for _, block in blocks do
        if block.rect:intersects(newrect) then
            self.vx = self.vx * (-1.0 + vb)
            self.vy = self.vy * (-1.0 + vb)
        end
    end
    --]]

    -- check hit against boundaries
    if newrect.x > xbound or newrect.x < -xbound then
        self.vx = self.vx * (-1.0 + vb)
    end
    if newrect.y > ybound or newrect.y < -ybound then
        self.vy = self.vy * (-1.0 + vb)
    end
    -- @hey: bottom boundary is fail

    -- change position as R + dR
    self.x = self.x + self.vx
    self.y = self.y + self.vy
end

function Ball:draw()
    self.rect.x = self.x
    self.rect.y = self.y
    self.rect:draw()
end

---------------------------

paddle = Paddle:new { x = 0, y = -0.8 }
ball = Ball:new { x = 0.0, y = 0.1, vx = -0.015, vy = 0.015 }
blocks = {};

-- game loop pulse
function pulse()
    paddle:move()
    paddle:draw()

    ball:move()
    ball:draw()
end

---------------------------
function describe(class, func)
    print(class)
    func()
    print()
end

function it(descr, func)
    if (func()) then
        print("- ", descr)
    else
        print("[fail] ", descr)
    end
end

function all_tests()
    describe("Rect", function()
        r1 = Rect:new { x = 0, y = 0, width = 3, height = 1 }
        r2 = Rect:new { x = 1, y = 0, width = 2, height = 2 }
        r3 = Rect:new { x = 4, y = 0, width = 2, height = 2 }

        it("intersects two rectangles", function()
            return r1:intersects(r2) == true
        end)

        it("doesn't intersect non-intersecting rectangles", function()
            return r1:intersects(r3) == false
        end)
    end)
end
