RegisterServerEvent("vorp_ml_doctorjob:checkjob")
AddEventHandler("vorp_ml_doctorjob:checkjob", function()
      local _souce = source
    TriggerEvent('vorp:getCharacter', _souce, function(user)
-- print(user.getJob())
print(user.job)
        if user.job == 'doctor' then
            TriggerClientEvent('vorp_ml_doctorjob:open', _souce)
        else
            print('not authorized')
        end
    end)
end)


RegisterServerEvent( 'vorp_ml_doctorjob:healplayer' )
AddEventHandler( 'vorp_ml_doctorjob:healplayer', function (target)
  TriggerClientEvent('vorp_ml_doctorjob:healed', target)
        print('server heal test')
end)

RegisterServerEvent( 'vorp_ml_doctorjob:reviveplayer' )
AddEventHandler( 'vorp_ml_doctorjob:reviveplayer', function (target)
    TriggerClientEvent('vorp:resurrectPlayer', target)
        print('server revive test')
end)


