local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

RegisterServerEvent("vorp_ml_doctorjob:checkjob")
AddEventHandler("vorp_ml_doctorjob:checkjob", function()
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local job = Character.job
    if job == 'doctor' then
        TriggerClientEvent('vorp_ml_doctorjob:open', _source)
    else
        print('not authorized')
    end
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


