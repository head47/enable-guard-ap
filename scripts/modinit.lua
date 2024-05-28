local refreshFlagOld

local function init( modApi )
    modApi.requirements = {"Sim Constructor"}
end

local function load( modApi, options )
    local flagui = include("hud/flag_ui")

    refreshFlagOld = refreshFlagOld or flagui.refreshFlag

    function flagui:refreshFlag( unit, isSelected )
        refreshFlagOld( self, unit, isSelected )

        unit = unit or self._rig:getUnit()

        if (unit:getPlayerOwner():isNPC() or unit:getTraits().takenDrone) and not unit:isKO() then
            self._widget.binder.meters:setVisible(true)

            local color
            local hud = self._rig._boardRig._game.hud
            
            self._widget.binder.meters.binder.selected:setVisible(false)
            if hud and hud:getSelectedUnit() == unit then
                color = {r=1,g=1,b=1,a=1}
                self._widget.binder.meters.binder.selected:setVisible(true)
            else
                if unit:isAiming() or unit:getTraits().isMeleeAiming then
                    color = {r=244/255,g=128/255,b=17/255,a=1}
                elseif unit:getTraits().takenDrone then
                    color = {r=140/255,g=255/255,b=255/255,a=1}
                else
                    color = {r=1,g=0.6,b=0.6,a=1}
                end
            end

            if unit:isAiming() or unit:getTraits().isMeleeAiming then
                self._widget.binder.meters.binder.overwatch:setVisible(true)
                self._widget.binder.meters.binder.overwatch:setColor(color.r,color.g,color.b,color.a)
            else 
                self._widget.binder.meters.binder.overwatch:setVisible(false)
            end
    
            if (self._moveCost or 0) < 0 then 
                self._widget.binder.meters.binder.APnum:setColor( cdefs.AP_COLOR_PREVIEW_BONUS:unpack() )
                self._widget.binder.meters.binder.APtxt:setColor( cdefs.AP_COLOR_PREVIEW_BONUS:unpack() )
            elseif (self._moveCost or 0) ~= 0 then
                self._widget.binder.meters.binder.APnum:setColor( cdefs.AP_COLOR_PREVIEW:unpack() )
                self._widget.binder.meters.binder.APtxt:setColor( cdefs.AP_COLOR_PREVIEW:unpack() )
            else
                self._widget.binder.meters.binder.APnum:setColor(color.r,color.g,color.b,color.a)
                self._widget.binder.meters.binder.APtxt:setColor(color.r,color.g,color.b,color.a)
            end
    
            self._widget.binder.meters.binder.bg:setColor(color.r,color.g,color.b,color.a)

            if self._widget.binder.brain:isVisible() then
                local x, y = self._widget.binder.brain:getPosition()
                self._widget.binder.brain:setPosition(-18, y)

                local x, y = self._widget.binder.meters:getPosition()
                self._widget.binder.meters:setPosition(-42, y)
            end

            local ap = math.floor( math.max( 0, unit:getMP() - (self._moveCost or 0) ))
			self._widget.binder.meters.binder.APnum:setText( ap )
        else
            local x, y = self._widget.binder.brain:getPosition()
            self._widget.binder.brain:setPosition(2, y)

            local x, y = self._widget.binder.meters:getPosition()
            self._widget.binder.meters:setPosition(-62, y)
        end
    end
end

return {
    init = init,
    load = load,
}
