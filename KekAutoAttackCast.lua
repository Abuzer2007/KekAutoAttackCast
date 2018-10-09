local AutoTrigerAttackCast = {}
AutoTrigerAttackCast.TrigerActiv = Menu.AddOption({"Utility"}, "AutoTrigerAttackCast", "")

function AutoTrigerAttackCast.OnUpdate()
    if not Menu.IsEnabled(AutoTrigerAttackCast.TrigerActiv) or not Heroes.GetLocal() or not Engine.IsInGame() then AutoTrigerAttackCast.TrigerActivation = false return end
    if AutoTrigerAttackCast.TrigerTimer > GameRules.GetGameTime() then return end
    for i = 0,24 do
        local abil = NPC.GetAbilityByIndex(Heroes.GetLocal(), i)
        if abil and Abilities.Contains(abil) and Ability.GetBehavior(abil) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_AUTOCAST ~= 0 and Ability.GetBehavior(abil) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_ATTACK ~= 0 then
            if AutoTrigerAttackCast.TrigerTarget then
                if not Ability.GetAutoCastState(abil) then
                    AutoTrigerAttackCast.Tombler(abil)
                    AutoTrigerAttackCast.TrigerTimer = GameRules.GetGameTime() + 0.5
                end
            else
                if Ability.GetAutoCastState(abil) then
                    AutoTrigerAttackCast.Tombler(abil)
                    AutoTrigerAttackCast.TrigerTimer = GameRules.GetGameTime() + 0.5
                end
            end
        end
    end
    AutoTrigerAttackCast.TrigerActivation = true
end

function AutoTrigerAttackCast.OnPrepareUnitOrders(orders)
    if AutoTrigerAttackCast.TrigerActivation then
        if orders.order == 4 then
            if orders.target and Heroes.Contains(orders.target) then
                AutoTrigerAttackCast.TrigerTarget = true
            else
                AutoTrigerAttackCast.TrigerTarget = false
            end
        else
            AutoTrigerAttackCast.TrigerTarget = false
        end
    end
    return true
end

function AutoTrigerAttackCast.Tombler(skill)
    Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO, Heroes.GetLocal(), Vector(0, 0, 0), skill, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, Heroes.GetLocal())
end

function AutoTrigerAttackCast.init()
    AutoTrigerAttackCast.TrigerActivation = false
    AutoTrigerAttackCast.TrigerTarget = false
    AutoTrigerAttackCast.TrigerTimer = 0
end
function AutoTrigerAttackCast.OnGameStart()
    AutoTrigerAttackCast.init()
end
function AutoTrigerAttackCast.OnGameEnd()
    AutoTrigerAttackCast.init()
end
AutoTrigerAttackCast.init()
return AutoTrigerAttackCast