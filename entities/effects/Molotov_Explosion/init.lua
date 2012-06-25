/*------------------------------
Molotov Explosion effect
	by Pac_187
---------------------------------*/



function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	local Pos = self.Position		 -- "Shortcut" für die Position
	local Norm = Vector(0,0,1)		 -- "Shortcut" für einen Vector
	
	Pos = Pos + Norm * 2 		-- Position (  kombiniert aus dem Pos-"Shortcut" + Norm-"Shortcut" * 2 )
	
	local emitter = ParticleEmitter( Pos ) 		-- "Shortcut" für den Effekt + Position
	
	-- Anfang unseres Effektes
			
		for i=1, 40 do
				
			local particle = emitter:Add( "sprites/flamelet"..tostring( math.random( 1, 5 ) ), Pos + Vector( math.random( -50, 50 ), math.random( -50, 50 ), math.random( 10, 150 ) ) ) -- Unser Effekt: (  "PFAD ZUM EFFEKT",  POSITION_DES_EFFEKTES )
				
				particle:SetVelocity( Vector( math.random( -50, 50), math.random( -50, 50 ), math.random( 5, 10 ) ) )			-- Geschwindigkeit mit der sich der Effekt bewegen soll
				particle:SetDieTime( math.random( 8, 10 ) ) 			-- Zeit in welcher der Effekt "seterben" soll
				particle:SetStartAlpha( math.random( 100, 200 ) ) 			-- Durchsichtigkeit des Effektes
				particle:SetStartSize( math.random( 40, 60 ) ) 			-- Anfangsgröße des Effektes
				particle:SetEndSize( math.random( 60, 90 ) ) 			-- Endgröße/Maximalgröße des Effektes
				particle:SetRoll( math.random( -360, 360 ) )			-- Wie schnell sich der Effekt "drehen" soll ( wie z.B. eine Rauchwolke)
				particle:SetRollDelta( math.random( -0.6, 0.6 ) ) 			-- <<Leider keine Ahungn>>
				particle:SetColor( 255, 255, 255 ) 			-- Farbe des Effektes ( Rot, Grün, Blau )
				particle:VelocityDecay( true )			 -- Ob die Geschwindigeit ( siehe oben ) "zerfallen" kann. Also, ob sich der Effekt langsamer bewegen darf
		end
			
		
		for i=1, 60 do
				
			local particle = emitter:Add( "particle/mat1", Pos + Vector( math.random( -150, 150 ), math.random( -150, 150 ), math.random( 20, 100 ) ) ) -- Unser Effekt: (  "PFAD ZUM EFFEKT",  POSITION_DES_EFFEKTES )
				
				particle:SetVelocity( Vector( math.random( -100, 100 ), math.random( -100, 100 ), math.random( 50, 100 ) ) )			-- Geschwindigkeit mit der sich der Effekt bewegen soll
				particle:SetDieTime( math.random( 8, 15 ) ) 			-- Zeit in welcher der Effekt "seterben" soll
				particle:SetStartAlpha( math.random( 150, 255 ) ) 			-- Durchsichtigkeit des Effektes
				particle:SetStartSize( math.random( 40, 80 ) ) 			-- Anfangsgröße des Effektes
				particle:SetEndSize( math.random( 100, 350 ) ) 			-- Endgröße/Maximalgröße des Effektes
				particle:SetRoll( math.random( -360, 360 ) )			-- Wie schnell sich der Effekt "drehen" soll ( wie z.B. eine Rauchwolke)
				particle:SetRollDelta( math.random( -0.8, 0.8 ) ) 			-- <<Leider keine Ahungn>>
				particle:SetColor( 255, 255, 255 ) 			-- Farbe des Effektes ( Rot, Grün, Blau )
				particle:VelocityDecay( true )			 -- Ob die Geschwindigeit ( siehe oben ) "zerfallen" kann. Also, ob sich der Effekt langsamer bewegen darf
		end
		
	-- Ende des Effekts	
		

end

function EFFECT:Think( )

	return false	
end


function EFFECT:Render()
end



