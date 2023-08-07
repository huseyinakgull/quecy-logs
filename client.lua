-- Örnek bir event ile LogGonder'ı çağırıyoruz.
RegisterCommand("testlog", function(source, args)
    TriggerServerEvent("logGonder:event", "Oyun içinde bir test olayı gerçekleşti.")
    TriggerEvent('chatMessage', "^2Test log gönderildi.")
end, false)
