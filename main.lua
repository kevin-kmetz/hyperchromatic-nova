

function love.load()
	--print("in load")

	math.randomseed(os.time())

	numOfHeights = math.random(3, 35)
	scale = 3
	width, height = 450 * scale, 300 * scale
	noiseGen = NoiseGenerator.new(math.random(1, 8), math.random() * 2.0, math.random() * 2.0)

	heightPalette = HeightPalette.new(numOfHeights)

	love.window.setMode(width, height, {resizable = false, vsync = false, fullscreen = false})

	lacFreq = math.random() * 2
	lacOffset = math.random(0, 100)

	persFreq = math.random() * 2
	persOffset = math.random(0, 100)



	theta = 0.0
	thetaIncr = math.random() / 25 + 0.01

end

function love.update(dt)
	--heightPalette:incrementHeights(0.02)
	--noiseGen:incrementLacunarity(0.03)
	--noiseGen:incrementPersistence(0.06)

	if changeColorsRequested then generateNewColors() end

	theta = theta + thetaIncr
	heightPalette:incrementHeights(0.02)
	noiseGen.lacunarity = (NoiseGenerator.lacunarityMax - NoiseGenerator.lacunarityMin) * (math.sin(lacFreq * theta + lacOffset) + 1) / 2 + NoiseGenerator.lacunarityMin
	noiseGen.persistence = (NoiseGenerator.persistenceMax - NoiseGenerator.persistenceMin) * (math.sin(persFreq * theta + persOffset) + 1) / 2 + NoiseGenerator.persistenceMin

end

function love.keypressed(key)

	if key == "c" then changeColorsRequested = true end

	return

end

function love.draw()
	--print("in draw")

	local min, max = math.huge, -(math.huge)

	for y = 0, height, scale do
		for x = 0, width, scale do

			mapHeight = noiseGen:getNoise(x, y)
			local r, g, b = heightPalette:getColor(mapHeight)

			love.graphics.setColor(r, g, b, 1.0)
			--love.graphics.points(x + 0.5, y + 0.5)

			love.graphics.rectangle("fill", x, y, scale, scale)

			if mapHeight < min then min = mapHeight end
			if mapHeight > max then max = mapHeight end

		end
	end

	--print("min: " .. min)
	--print("max: " .. max)

end

function generateNewColors()

	for i = 1, #heightPalette.colorAt do

		local nR, nG, nB = math.random(), math.random(), math.random()
		heightPalette.colorAt[i] = {r = nR, g = nG, b = nG, height = heightPalette.colorAt[i].height}

	end

	changeColorsRequested = false

	return

end

NoiseGenerator = {lacunarityMin = 0.0, lacunarityMax = 3.0, persistenceMin = 0.0, persistenceMax = 2.0}

function NoiseGenerator.new(octaves, persistence, lacunarity, seed)

	if octaves == nil then octaves = 4 end
	if persistence == nil then persistence = 0.8 end
	if lacunarity == nil then lacunarity = 0.4 end
	if seed == nil then seed = math.random() end

	newNG = {}
	newNG.octaves = octaves
	newNG.persistence = persistence
	newNG.lacunarity = lacunarity
	newNG.seed = seed

	print("octaves: ", octaves)
	print("persistence: ", persistence)
	print("lacunarity: ", lacunarity)

	setmetatable(newNG, {__index = NoiseGenerator})
	return newNG

end

function NoiseGenerator:getNoise(x, y)

	local totalNoise = 0
	local currentFrequency = 1
	local currentAmplitude = 1
	local summedAmplitudes = 0

		for i = 0, self.octaves - 1 do

			totalNoise = totalNoise + love.math.noise(x * currentFrequency / 100, y * currentFrequency / 100) * currentAmplitude
			summedAmplitudes = summedAmplitudes + currentAmplitude

			currentAmplitude = currentAmplitude * self.persistence;
			currentFrequency = currentFrequency * self.lacunarity;

		end

		outputNoise = totalNoise / summedAmplitudes

		return outputNoise

end

HeightPalette = {}

function HeightPalette.new(numOfColors)

	if numOfColors == nil then numOfColors = math.floor(math.random() * 20) end
	print("there will be " .. numOfColors .. " colors")

	local newHP = {}
	newHP.colorAt = {}

	local randHeights = getRandomArray(numOfColors)

	for i = 1, numOfColors do
		local r, g, b = math.random(), math.random(), math.random()
		newHP.colorAt[i] = {r = math.random(), g = math.random(), b = math.random(), height = randHeights[i]}
	end

	for i = 1, numOfColors do print("At height " .. twoDecimals(newHP.colorAt[i].height) .. " the color is " .. twoDecimals(newHP.colorAt[i].r) .. ", " .. twoDecimals(newHP.colorAt[i].g) .. ", " .. twoDecimals(newHP.colorAt[i].b)) end

	setmetatable(newHP, {__index = HeightPalette})
	return newHP

end

function HeightPalette:getColor(mheight)

	local h_r, h_g, h_b = self.colorAt[1].r, self.colorAt[1].g, self.colorAt[1].b

	for i = 1, #self.colorAt do

		if mheight <  self.colorAt[i].height then
			return self.colorAt[i].r, self.colorAt[i].g, self.colorAt[i].b
		end

	end

	return h_r, h_g, h_b

end

function HeightPalette:incrementHeights(incremental)

	for i = 1, #self.colorAt do
		self.colorAt[i].height = self.colorAt[i].height + incremental
		if self.colorAt[i].height > 1.0 then self.colorAt[i].height = self.colorAt[i].height - 1.0; print("fronted") end
	end

	swapPerformed = true

	while swapPerformed do

		swapPerformed = false

		for i = 1, #self.colorAt - 1 do
			--print(i, i + 1)
			--print(twoDecimals(self.colorAt[i].height))
			--print(twoDecimals(self.colorAt[i + 1].height))
			if self.colorAt[i].height > self.colorAt[i + 1].height then
				--print("swapping", twoDecimals(self.colorAt[i].height), twoDecimals(self.colorAt[i + 1].height))
				local tmp = {r = self.colorAt[i + 1].r, g = self.colorAt[i + 1].g, b = self.colorAt[i + 1].b, height = self.colorAt[i + 1].height}
				self.colorAt[i + 1].r = self.colorAt[i].r
				self.colorAt[i + 1].g = self.colorAt[i].g
				self.colorAt[i + 1].b = self.colorAt[i].b
				self.colorAt[i + 1].height = self.colorAt[i].height
				self.colorAt[i].r = tmp.r
				self.colorAt[i].g = tmp.g
				self.colorAt[i].b = tmp.b
				self.colorAt[i].height = tmp.height
				swapPerformed = true
			end
		end

	end

end

function NoiseGenerator:incrementLacunarity(incremental)

	self.lacunarity = self.lacunarity + incremental
	if self.lacunarity > NoiseGenerator.lacunarityMax then self.lacunarity = self.lacunarity - (NoiseGenerator.lacunarityMax - NoiseGenerator.lacunarityMin) end

end

function NoiseGenerator:incrementPersistence(incremental)

	self.persistence = self.persistence + incremental
	if self.persistence > NoiseGenerator.persistenceMax then self.persistence = self.persistence - (NoiseGenerator.persistenceMax - NoiseGenerator.persistenceMin) end

end

function getRandomArray(numOfValues)

	randomArray = {}

	for i = 1, numOfValues do
		randomArray[i] = math.random()
	end

	swapPerformed = true

	while swapPerformed do

		swapPerformed = false

		for i = 1, numOfValues - 1 do
			if randomArray[i] > randomArray[i + 1] then
				local tmp = randomArray[i + 1]
				randomArray[i + 1] = randomArray[i]
				randomArray[i] = tmp
				swapPerformed = true
			end
		end

	end

	return randomArray

end

function twoDecimals(number)
	return math.modf(number * 100) / 100
end