-- hyperchromatic/main.lua

require("fennel").install()

local hyperchromatic = require "hyperchromatic"

-- HyperChromatic-Nova overrides nearly all of Love2d's core functions,
-- instead opting to use it primarily as a runtime and supporting library.
--
-- This is done so that the project can be implemented in a style that adheres
-- more closely to functional programming pinciples.

love.load = nil
love.draw = nil
love.update = nil

love.run = hyperchromatic["run!"]
