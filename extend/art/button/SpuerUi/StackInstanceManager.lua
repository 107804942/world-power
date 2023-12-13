
local HiddenControls = Controls.Scrap

function StackInstanceManager( instanceName, rootControlName, parentControl, collapseControl, collapseFunction, collapseControlAlwaysShown, isCollapsed )
	local instanceCount = 0
	local Collapse
	if not HiddenControls then
		HiddenControls = {}
		ContextPtr:BuildInstance( instanceName, HiddenControls )
		HiddenControls = HiddenControls[ rootControlName ]
		if HiddenControls~=nil then
		HiddenControls:SetHide( true )
		end
	end
	if parentControl then
		if collapseControl then
			Collapse = function( value )
				if value ~= nil then
					isCollapsed = value
					parentControl:SetHide( value )
					collapseControl:SetText( value and "[ICON_PLUS]" or "[ICON_MINUS]" )
					if collapseFunction then
						collapseFunction( isCollapsed )
					end
				end
				return isCollapsed
			end
			collapseControl:GetTextControl():SetAnchor( "L,C" )
			collapseControl:GetTextControl():SetOffsetVal( 12, -2 )
			collapseControl:RegisterCallback( Mouse.eLClick, function() Collapse( not isCollapsed ) end )
			Collapse( isCollapsed or false )
		end
	end
	return {
		GetInstance = parentControl and
		function(self)
			instanceCount = instanceCount+1
			local instance = self[ instanceCount ]
			if instance then
				instance[rootControlName]:ChangeParent( parentControl )
				return instance
			else
				instance = {}
				ContextPtr:BuildInstanceForControl( instanceName, instance, parentControl )
				self[ instanceCount ] = instance
				return instance, true
			end
		end
		or
		function(self, parentControl)
			instanceCount = instanceCount+1
			local instance = self[ instanceCount ]
			if instance then
				instance[rootControlName]:ChangeParent( parentControl )
				return instance
			else
				instance = {}
				ContextPtr:BuildInstanceForControl( instanceName, instance, parentControl )
				self[ instanceCount ] = instance
				return instance, true
			end
		end,
		ResetInstances = function(self)
			local HiddenControls = HiddenControls
			local rootControlName = rootControlName
			for i = 1, instanceCount do
				self[i][rootControlName]:ChangeParent( HiddenControls )
			end
			instanceCount = 0
		end,
		ReleaseInstance = function(self, instance)
			for i = 1, instanceCount do
				if self[i] == instance then
					instance[rootControlName]:ChangeParent( HiddenControls )
					table.remove( self, i )
					table.insert( self, instance )
					instanceCount = instanceCount-1
					return
				end
			end
			print( "Error: InstanceManager cannot find ReleaseInstance", instanceName, rootControlName )
		end,
		Commit = parentControl and parentControl.CalculateSize and (collapseControl and not collapseControlAlwaysShown and 
		function()
			collapseControl:SetHide( instanceCount < 1 )
			parentControl:CalculateSize()
		end
		or function()
			parentControl:CalculateSize()
		end),
		Collapse = Collapse,
	}
end
