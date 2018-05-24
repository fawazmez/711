-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Created by: Fawaz Mezher
-- Created on: may 2018
--
-- adding spritesheets to physics
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 )
physics.setDrawMode( "default" )

local playerBullets = {} -- table for bullets
local score = 0
local timeOfAnimation = tonumber( 750 )

local theGround = display.newImage( "./assets/sprites/land.png" )
theGround.x = display.contentCenterX - 600
theGround.y = display.contentHeight
theGround.id = "the ground"
physics.addBody( theGround, 'static', {
    friction = 0.5, 
    bounce = 0.3 
    } )

local theGround2 = display.newImage( "./assets/sprites/land.png" )
theGround2.x = 1450
theGround2.y = display.contentHeight
theGround2.id = "the ground"
physics.addBody( theGround2, 'static', {
    friction = 0.5, 
    bounce = 0.3 
    } )

local leftWall = display.newRect( 0, display.contentHeight / 2, 1, display.contentHeight )
physics.addBody( leftWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )
leftWall.id = "Left Wall"

local scoreText = display.newText( 'Score:', 200, 100, native.systemFont, 128 )

local sheetOptionsIdleBoy = {
    width = 232,
    height = 439,
    numFrames = 10 
}

local sheetIdleNinjaBoy = graphics.newImageSheet( "./assets/spritesheets/ninjaBoyIdle.png", sheetOptionsIdleBoy )

local sheetOptionsRunBoy = {
    width = 363,
    height = 458,
    numFrames = 10
}

local sheetRunNinjaBoy = graphics.newImageSheet( "./assets/spritesheets/ninjaBoyJumpRun.png", sheetOptionsRunBoy )

local sheetOptionsIdleGirl = {
    width = 290,
    height = 500,
    numFrames = 10
}

local sheetIdleNinjaGirl = graphics.newImageSheet( "./assets/spritesheets/ninjaGirlIdle.png", sheetOptionsIdleGirl )

local sheetOptionsDeadGirl = {
    width = 578,
    height = 599,
    numFrames = 10
}

local sheetDeadNinjaGirl = graphics.newImageSheet( "./assets/spritesheets/ninjaGirlDead.png", sheetOptionsDeadGirl )

local sheetOptionsJumpBoy = {
    width = 362,
    height = 483,
    numFrames = 10
}

local sheetJumpNinjaBoy = graphics.newImageSheet( "./assets/spritesheets/ninjaBoyJump.png", sheetOptionsJumpBoy )

local sheetOptionsThrowBoy = {
    width = 377,
    height = 451,
    numFrames = 10
}

local sheetThrowNinjaBoy = graphics.newImageSheet ( "./assets/spritesheets/ninjaBoyThrow.png", sheetOptionsThrowBoy )

-- sequence table
local sequence_data = {
    {
        name = "idleBoy",
        start = 1,
        count  = 10,
        time = timeOfAnimation,
        loopCount = 0,
        sheet = sheetIdleNinjaBoy

    },
    {
        name = "runBoy",
        start = 1,
        count  = 10,
        time = timeOfAnimation,
        loopCount = 1,
        sheet = sheetRunNinjaBoy
    },
    {
        name = "idleGirl",
        start = 1,
        count  = 10,
        time = timeOfAnimation,
        loopCount = 0,
        sheet = sheetIdleNinjaGirl
    },
    {
        name = "deadGirl",
        start = 1,
        count  = 10,
        time = timeOfAnimation,
        loopCount = 1,
        sheet = sheetDeadNinjaGirl
    },
    {
        name = "jumpBoy", 
        start = 1,
        count = 10,
        time = 2000,
        loopCount = 1,
        sheet = sheetJumpNinjaBoy
    },
    {
        name = "throwBoy",
        start = 1,
        count = 10,
        time = timeOfAnimation,
        loopCount = 1,
        sheet = sheetThrowNinjaBoy
    }
}

local ninjaBoy = display.newSprite( sheetIdleNinjaBoy, sequence_data)
ninjaBoy.x = display.contentCenterX - 800
ninjaBoy.y = display.contentCenterY
ninjaBoy.id = "the character"
physics.addBody( ninjaBoy, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )
ninjaBoy.isFixedRotation = true
ninjaBoy:setSequence( "idleBoy" )
ninjaBoy:play()

local ninjaGirl = display.newSprite( sheetIdleNinjaGirl, sequence_data)
ninjaGirl.x = display.contentCenterX 
ninjaGirl.y = display.contentCenterY
ninjaGirl.id = "enemy character"
ninjaGirl.xScale = -1
physics.addBody( ninjaGirl, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )
ninjaGirl.isFixedRotation = true
ninjaGirl:setSequence( "idleGirl")
ninjaGirl:play()

local dPad = display.newImage( "./assets/sprites/d-pad.png" )
dPad.x = 150
dPad.y = display.contentHeight - 200
dPad.id = "d-pad"


local upArrow = display.newImage( "./assets/sprites/upArrow.png" )
upArrow.x = 150
upArrow.y = display.contentHeight - 310
upArrow.id = "up arrow"


local downArrow = display.newImage( "./assets/sprites/downArrow.png" )
downArrow.x = 150
downArrow.y = display.contentHeight - 90
downArrow.id = "down arrow"


local leftArrow = display.newImage( "./assets/sprites/leftArrow.png" )
leftArrow.x = 40
leftArrow.y = display.contentHeight - 200
leftArrow.id = "left arrow"



local rightArrow = display.newImage( "./assets/sprites/rightArrow.png" )
rightArrow.x = 260
rightArrow.y = display.contentHeight - 200
rightArrow.id = "right arrow"

local jumpButton = display.newImage( "./assets/sprites/jumpButton.png" )
jumpButton.x = display.contentWidth - 80
jumpButton.y = display.contentHeight - 80
jumpButton.id = "jump button"
jumpButton.alpha = 0.5

local shootButton = display.newImage( "./assets/sprites/jumpButton.png" )
shootButton.x = display.contentWidth - 250
shootButton.y = display.contentHeight - 80
shootButton.id = "shootButton"
shootButton.alpha = 0.5

local function resetIdleBoy( event )
    if (event.phase == 'ended') then
    -- go back to Idle animation for ninja Boy
    ninjaBoy:setSequence( 'idleBoy')
    ninjaBoy:play()
    end
end


local function characterCollision( self, event )
    -- print what the chararcter collided with
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end

local function checkPlayerBulletsOutOfBounds()
	-- check if bullets are off the screen and rmoves them 
	local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 ,-1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end

local function checkCharacterPosition( event )
    -- respawn character if it falls off the map
    if ninjaBoy.y > display.contentHeight + 500 then
        ninjaBoy.x = display.contentCenterX - 200
        ninjaBoy.y = display.contentCenterY
    end
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.id == "enemy character" and obj2.id == "bullet" ) or
             ( obj1.id == "bullet" and obj2.id == "enemy character" ) ) then
            -- Table of emitter parameters
            local emitterParams = {
                startColorAlpha = 1,
                startParticleSizeVariance = 500,
                startColorGreen = 0,
                yCoordFlipped = -1,
                blendFuncSource = 770,
                rotatePerSecondVariance = 153.95,
                particleLifespan = 0.8,
                tangentialAcceleration = -1440.74,
                finishColorBlue = 0.5,
                finishColorGreen = 0,
                blendFuncDestination = 1,
                startParticleSize = 400.95,
                startColorRed = 0.8373094,
                textureFileName = "./assets/sprites/fire.png",
                startColorVarianceAlpha = 1,
                maxParticles = 256,
                finishParticleSize = 600,
                duration = 0.25,
                finishColorRed = 1,
                maxRadiusVariance = 72.63,
                finishParticleSizeVariance = 250,
                gravityy = 671.05,
                speedVariance = 90.79,
                tangentialAccelVariance = -420.11,
                angleVariance = -142.62,
                angle = -244.11
            }
            -- show explosion
            local emitter = display.newEmitter( emitterParams )
            emitter.x = obj1.x
            emitter.y = obj1.y

 			-- Remove bullet
            for bulletCounter = #playerBullets, 1, -1 do
                if ( playerBullets[bulletCounter] == obj1 or playerBullets[bulletCounter] == obj2 ) then
                    playerBullets[bulletCounter]:removeSelf()
                    playerBullets[bulletCounter] = nil
                    table.remove( playerBullets, bulletCounter )
                    break
                end
            end


            -- Remove character
            ninjaGirl:setSequence( 'deadGirl' )
            ninjaGirl:play()
            transition.fadeOut( ninjaGirl, { time = 1300 } )
            
            -- remove after delay
            local function removeNinjaGirl( event )
                ninjaGirl:removeSelf()
                ninjaGirl = nil
            end

            timer.performWithDelay( 1200, removeNinjaGirl )

            -- Increase score
            score = score + 1 

            -- Play Explosion sound 
            local expolsionSound = audio.loadSound( "./assets/audio/bombExplosion.wav" )
            audio.play( expolsionSound )

        end
    end
end


local function checkScore( event )
    if score > 0 then
        local scoreNumberText = display.newText( score, 450, 100, native.systemFont, 128 )
    end
end

function rightArrow:touch( event )
    if ( event.phase == "ended" ) then 
        -- moves ninja Boy right 
        ninjaBoy.xScale = 1
        transition.moveBy( ninjaBoy, {
            x = 100, --move 100 pixels right
            y = 0, -- move 0 pixels vertically
            time = timeOfAnimation -- move as long as animation
            } )
        ninjaBoy:setSequence( "runBoy")
        ninjaBoy:play()
    end

    return true
end

function leftArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- moves character left
        ninjaBoy.xScale = -1
        transition.moveBy( ninjaBoy, { 
            x = - 100, -- move 100 pixels left
            y = 0, -- move 0 pixels vertically
            time = timeOfAnimation -- move as long as animation
            } )
        ninjaBoy:setSequence( "runBoy" )
        ninjaBoy:play()
    end

    return true
end

function jumpButton:touch( event )
    if ( event.phase == "ended" ) then
        -- makes character jump
        ninjaBoy:setLinearVelocity( 200, -750 )
        ninjaBoy:setSequence( "jumpBoy" )
        ninjaBoy:play()
    end

    return true
end

function shootButton:touch( event )
    if ( event.phase == "began" ) then
        -- use function to delay throw to match animation
        local function delayThrow( event )
            local aSingleBullet = display.newImage( "./assets/sprites/kunai.png" )
             -- puts bullet on screen at character postion
            aSingleBullet.x = ninjaBoy.x
            aSingleBullet.y = ninjaBoy.y
            physics.addBody( aSingleBullet, 'dynamic' )
            -- Makes sprite a "bullet" type object
            aSingleBullet.isBullet = true
            aSingleBullet.gravityScale = 0
            aSingleBullet.id = "bullet"
            aSingleBullet:setLinearVelocity( 1500, 0 )
            aSingleBullet.isFixedRotation = true
    
            table.insert(playerBullets,aSingleBullet)
            print("# of bullet: " .. tostring(#playerBullets))    
        end 
        timer.performWithDelay( 200, delayThrow )
        
        ninjaBoy:setSequence( "throwBoy")
        ninjaBoy:play()
    end

    return true
end

rightArrow:addEventListener( "touch", rightArrow )
leftArrow:addEventListener( "touch", leftArrow )
jumpButton:addEventListener( "touch", jumpButton )
shootButton:addEventListener( "touch", shootButton )

ninjaBoy.collision = characterCollision
ninjaBoy:addEventListener( 'collision')

Runtime:addEventListener( "enterFrame", checkCharacterPosition )
Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )
Runtime:addEventListener( "collision", onCollision )
Runtime:addEventListener( "enterFrame", checkScore )
ninjaBoy:addEventListener( "sprite", resetIdleBoy )