
icondisplay = class()
icondisplay.maxParentCount = 1
icondisplay.maxChildCount = 0
icondisplay.connectionInput = sm.interactable.connectionType.logic
icondisplay.connectionOutput = sm.interactable.connectionType.none


function icondisplay:server_onCreate(  )
	self.saved = self.storage:load()
	if self.saved == nil then
		self.saved = {}
	end
	
	self.selectedIconPog = "gui_icon_alert.png"
		
		if tostring(self.shape:getShapeUuid()) == "cee1a3e5-7734-45b0-861f-3dfecf3d94e5" then --SPACESHIP
			self.selectedIconPog = "icon_spaceship_large.png"
		elseif tostring(self.shape:getShapeUuid()) == "f0377f58-0bba-480f-9ec9-46348995a037" then --MECH STATION
			self.selectedIconPog = "icon_mechanicstation_large.png"
		elseif tostring(self.shape:getShapeUuid()) == "2d3a82a3-076e-45bd-8367-8f0f1abf6010" then --DEATHBAG
			self.selectedIconPog = "icon_lostitem_large.png"
		end
	
		
		
end


function icondisplay:server_onFixedUpdate( timeStep ) 


--print(self:inputActive())


end

function icondisplay:client_onCreate(  )
		self.cl = {}

		self.parentActive = false
		self.isActiveF = true
		
		
	
		self.cl.iconGui = sm.gui.createWorldIconGui( 50, 50, "$GAME_DATA/Gui/Layouts/Hud/Hud_WorldIcon.layout", false )
		self.cl.iconGui:setImage( "Icon", self.selectedIconPog )
		self.cl.iconGui:setHost( self.shape )
		self.cl.iconGui:setRequireLineOfSight( false )
		self.cl.iconGui:open()
		self.cl.iconGui:setMaxRenderDistance( 10000 )
		
		self.wasActive = true
	

end

function icondisplay:client_onFixedUpdate(dt)
	local b_parentIsActive = self:inputActive()
	local parent = self.interactable:getSingleParent();
	
	
	if parent then
		if self:inputActive() then

			if not self.wasActive then
	
				self.cl.iconGui:open()
				self.cl.iconGui:setImage( "Icon", self.selectedIconPog )
				self.cl.iconGui:setHost( self.shape )
				self.cl.iconGui:setRequireLineOfSight( false )
				self.cl.iconGui:open()
				self.cl.iconGui:setMaxRenderDistance( 10000 )
			
				print("open1")
			end
	
			self.wasActive = true
	
		else
	
			if self.wasActive then
				self.cl.iconGui:close()
				print("close1")
				self.wasActive = false
			end
			self.wasActive = false
			
		end
		
	elseif self.isActiveF and not self.wasActive then
		
		self.cl.iconGui:open()
		self.cl.iconGui:setImage( "Icon", self.selectedIconPog )
		self.cl.iconGui:setHost( self.shape )
		self.cl.iconGui:setRequireLineOfSight( false )
		self.cl.iconGui:open()
		self.cl.iconGui:setMaxRenderDistance( 10000 )
		self.wasActive = true
			
		print("open2")
				
	elseif not self.isActiveF and self.wasActive then
				
		self.cl.iconGui:close()
		print("close2")
		self.wasActive = false
				

				
	end
		
		
	
	
	

end



function icondisplay:inputActive()
	local parent = self.interactable:getSingleParent();

	if parent then
		if parent:hasOutputType(sm.interactable.connectionType.logic) then
			return parent:isActive()
		end
	end
	return false
end





function icondisplay:client_onInteract( character, state )
	if state then
		self.isActiveF = not self.isActiveF
	end
end



function icondisplay.client_onDestroy( self )
self.cl.iconGui:close()
end
	


