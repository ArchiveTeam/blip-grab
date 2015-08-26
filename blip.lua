dofile("urlcode.lua")
dofile("table_show.lua")

local url_count = 0
local tries = 0
local item_type = os.getenv('item_type')
local item_value = os.getenv('item_value')

local downloaded = {}
local addedtolist = {}
local removedlist = {}
local goodurl = {}

local removed = false
local showname = nil
local lastpage = nil

-- Do not download folowing urls:
downloaded["http://a.blip.tv/api.swf"] = true
downloaded["http://a.blip.tv/"] = true
downloaded["http://a.blip.tv/skin/smooth/compiled/modal.2d4f867.css"] = true
downloaded["http://a.blip.tv/images/blank.gif"] = true
downloaded["http://a.blip.tv/scripts/BLIP/DestinationEpisode.2d4f867.js"] = true
downloaded["http://a.blip.tv/scripts/BLIP/DestinationCommon.2d4f867.js"] = true
downloaded["http://a.blip.tv/scripts/BLIP/DestinationAnalytics.2d4f867.js"] = true
downloaded["http://a.blip.tv/channel.html"] = true
downloaded["http://a.blip.tv/images/apple-touch-icon-iphone4.png"] = true
downloaded["http://a.blip.tv/images/apple-touch-icon-ipad.png"] = true
downloaded["http://a.blip.tv/images/apple-touch-icon-iphone.png"] = true
downloaded["http://a.blip.tv/skin/smooth/endcap.2d4f867.css"] = true
downloaded["http://a.blip.tv/skin/smooth/episodePage.2d4f867.css"] = true
downloaded["http://a.blip.tv/skin/smooth/common.2d4f867.css"] = true
downloaded["http://a.blip.tv/p/blip-player.eb25d35.js"] = true
downloaded["http://a.blip.tv/scripts/flash/stratos.swf"] = true
downloaded["http://a.blip.tv/skin/smooth/standardEndCap.2d4f867.css"] = true
downloaded["http://a.blip.tv/p/blip-player.eb25d35.css"] = true
downloaded["http://a.blip.tv/skin/mercury/dashboard/images/dashboard.loading.gif"] = true
downloaded["http://a.blip.tv/skin/mercury/dashboard/images/modal.bg.alpha30.png"] = true
downloaded["http://a.blip.tv/skin/mercury/dashboard/images/modal.bg.alpha50.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/endcap-bg.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/endcap-sidebar-shadow.png"] = true
downloaded["https://fonts.googleapis.com/css?family=PT+Sans:400,700"] = true
downloaded["http://a.blip.tv/skin/smooth/dark_background_stripes.gif"] = true
downloaded["http://a.blip.tv/skin/smooth/fonts/BlipIcons-Roman.eot?"] = true
downloaded["http://a.blip.tv/skin/smooth/fonts/BlipIcons-Roman.woff"] = true
downloaded["http://a.blip.tv/skin/smooth/fonts/BlipIcons-Roman.ttf"] = true
downloaded["http://a.blip.tv/skin/smooth/fonts/BlipIcons-Roman.svg"] = true
downloaded["http://a.blip.tv/skin/smooth/images/icons-sprite.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/masthead/sprite.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/masthead/sprite.svg"] = true
downloaded["http://a.blip.tv/skin/smooth/images/masthead/tpc-nav-imagery-sm.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/masthead/tpc-nav-imagery-lg.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/iphone-user-action-sprite.gif"] = true
downloaded["http://a.blip.tv/skin/smooth/images/icon-search.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/masthead/tpc-logo-small-combined.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/masthead/tpc-logo-small.svg"] = true
downloaded["http://a.blip.tv/skin/smooth/images/background-facebook-masthead.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/actionTabBackground.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/actionTabBackground@2x.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/scrollbar-bg.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/scrollbar-handle-bg.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/icon-close-x.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/icon-blip-42px.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/icon-fb-connect-large.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/icon-fb-connect-large-invert.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/button-show-links-bg.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/noresult.card.bg.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/private.lock.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/private.key.png"] = true
downloaded["http://a.blip.tv/skin/smooth/images/blip-logo-smallscreen@2x.png"] = true
downloaded["https://fonts.gstatic.com/s/ptsans/v8/FUDHvzEKSJww3kCxuiAo2A.ttf"] = true
downloaded["https://fonts.gstatic.com/s/ptsans/v8/0XxGQsSc1g4rdRdjJKZrNC3USBnSvpkopQaUR-2r7iU.ttf"] = true

read_file = function(file)
  if file then
    local f = assert(io.open(file))
    local data = f:read("*all")
    f:close()
    return data
  else
    return ""
  end
end

wget.callbacks.download_child_p = function(urlpos, parent, depth, start_url_parsed, iri, verdict, reason)
  local url = urlpos["url"]["url"]
  local html = urlpos["link_expect_html"]
  
  if downloaded[url] == true or addedtolist[url] == true then
    return false
  end
  
  if (downloaded[url] ~= true or addedtolist[url] ~= true) then
    if html == 0 or (string.match(url, "[^0-9]"..item_value) and not string.match(url, "[^0-9]"..item_value.."[0-9]")) or (item_type == 'show' and (string.match(url, "blip%.tv/([^/]+)") == showname or string.match(url, "[^a-z0-9]"..item_value))) then
      addedtolist[url] = true
      return true
    else
      return false
    end
  else
    return false
  end
end


wget.callbacks.get_urls = function(file, url, is_css, iri)
  local urls = {}
  local html = nil
  
  local function check(url)
    if ((string.match(url, "[^0-9]"..item_value) or string.match(url, "images%.blip%.tv") or string.match(url, "blip%.tv/play/") or string.match(url, "i%.blip%.tv") or string.match(url, "a%.blip%.tv")) and (downloaded[url] ~= true and addedtolist[url] ~= true) and not (string.match(url, "tumblr%.com") or string.match(url, "twitter%.com") or string.match(url, "[^0-9]"..item_value.."[0-9]") or string.match(url, "%.mp4") or string.match(url, "%.m4v") or string.match(url, ">") or string.match(url, "<"))) or (item_type == 'show' and ((string.match(url, "[^a-z0-9]"..item_value) or string.match(url, "blip%.tv/([^/]+)") == showname or string.match(url, "images%.blip%.tv") or string.match(url, "blip%.tv/play/") or string.match(url, "i%.blip%.tv") or string.match(url, "a%.blip%.tv")) and (downloaded[url] ~= true and addedtolist[url] ~= true) and not ((string.match(url, "blip%.tv/([^/]+)") == showname and string.match(url, "blip%.tv/[^/]+/.+%-[0-9]+")) or string.match(url, "tumblr%.com") or string.match(url, "twitter%.com") or string.match(url, ">") or string.match(url, "<")))) then
      if string.match(url, "THUMB_WIDTH") and string.match(url, "THUMB_HEIGHT") then
        check(string.gsub(string.gsub(url, "THUMB_WIDTH", "40"), "THUMB_HEIGHT", "36"))
      elseif string.match(url, "&amp;") then
        table.insert(urls, { url=string.gsub(url, "&amp;", "&") })
        addedtolist[url] = true
        addedtolist[string.gsub(url, "&amp;", "&")] = true
      else
        table.insert(urls, { url=url })
        addedtolist[url] = true
      end
    end
  end
  
  local function checkvideo(url)
    if goodurl[url] ~= true then
      io.stdout:write("Checking if server returns data for "..url.."\n")
      io.stdout:flush()
      os.execute("python returneddata.py '"..url.."'")
      local returneddata = io.open("returned", "r")
      local fulldata = returneddata:read("*all")
      if fulldata == 'True' then
        io.stdout:write("Data is returned, added URL to downloadlist.\n")
        io.stdout:flush()
        goodurl[url] = true
        checkvideo(url)
      else
        io.stdout:write("No data was returned, skipping URL.\n")
        io.stdout:flush()
      end
    else
      table.insert(urls, { url=url })
      addedtolist[url] = true
    end
  end

  if item_type == 'show' and showname == nil and not string.match(url, "https?://blip%.tv/[^/]+/") then
    showname = string.match(url, "https?://blip%.tv/(.+)")
  end

  if item_type == 'show' and (string.match(url, item_value) or string.match(url, "blip%.tv/([^/]+)") == showname) then
    html = read_file(file)
    if showname == nil then
      showname = string.match(html, '"og:title"%s+content="([^"]+)"')
    end
    if string.match(url, "get_recommended_shows") then
      local lpage = string.match(html, '"LastPage">([0-9]+)<') + 2
      while lpage >= 0 do
        check("http://blip.tv/show/get_recommended_shows?users_id="..item_value.."&no_wrap=1&esi=1&page="..lpage)
        check("http://blip.tv/show/get_recommended_shows?users_id="..item_value.."&no_wrap=0&esi=1&page="..lpage)
        check("http://blip.tv/show/get_recommended_shows?users_id="..item_value.."&no_wrap=1&esi=1&page="..lpage)
        check("http://blip.tv/show/get_recommended_shows?users_id="..item_value.."&no_wrap=0&esi=1&page="..lpage)
        lpage = lpage - 1
      end
    end
    if (lastpage == nil and string.match(url, "blip%.tv/([^/]+)") == showname) or (string.match(url, "show_get_full_episode_list") and not string.match(url, "page=0")) then
      lastpage = string.match(html, '"LastPage">([0-9]+)<') + 2
      while lastpage >= 0 do
        check("http://blip.tv/pr/show_get_full_episode_list?users_id="..item_value.."&lite=0&esi=1&page="..lastpage)
        check("http://blip.tv/pr/show_get_full_episode_list?users_id="..item_value.."&lite=1&esi=1&page="..lastpage)
        check("http://blip.tv/pr/show_get_full_episode_list?users_id="..item_value.."&lite=0&esi=0&page="..lastpage)
        check("http://blip.tv/pr/show_get_full_episode_list?users_id="..item_value.."&lite=1&esi=0&page="..lastpage)
        lastpage = lastpage - 1
      end
    end
    for newurl in string.gmatch(html, '"(https?://[^"]+)"') do
      check(newurl)
    end
    for newurl in string.gmatch(html, "'(https?://[^']+)'") do
      check(newurl)
    end
    for newurl in string.gmatch(html, '("/[^"]+)"') do
      if string.match(newurl, '"//') then
        check(string.gsub(newurl, '"//', 'http://'))
      else
        check(string.match(url, '(https?://[^/]+)/')..string.match(newurl, '"(.+)'))
      end
    end
    for newurl in string.gmatch(html, "('/[^']+)'") do
      if string.match(newurl, "'//") then
        check(string.gsub(newurl, "'//", "http://"))
      else
        check(string.match(url, "(https?://[^/]+)/")..string.match(newurl, "'(.+)"))
      end
    end
  end
  
  if item_type == 'video' and (string.match(url, item_value) or string.match(url, "blip%.tv/play/") or string.match(url, "blip%.tv/file/get/")) and not string.match(url, "^http://a%.blip%.tv/scripts/flash/stratos%.swf") then
    html = read_file(file)
    if string.match(url, "blip%.tv/players/standard%?no_wrap=") then
      check("http://a.blip.tv/scripts/flash/stratos.swf?file=http://blip.tv/rss/flash/"..item_value.."&autostart="..string.match(html, "config%.autoplay%s+=%s+([a-z]+)").."&showinfo=false&onsite=true&nopostroll=true&noendcap=true&showsharebutton=false&removebrandlink=false&page=episode&skin=BlipClassic&frontcolor=0x999999&lightcolor=0xAAAAAA&basecolor=0x1E1E1E&backcolor=0x1E1E1E&floatcontrols=true&fixedcontrols=true&largeplaybutton=true&controlsalpha=.8&autohideidle=6000&utm_campaign=&adprovider=auditude&zoneid=127323&referrer=http%3A%2F%2Fblip.tv&destinationtag=blip_tv")
    end
    for newurl in string.gmatch(html, 'url="(https?://[^"]+)" blip:role="Source"') do
      if downloaded[newurl] ~= true and addedtolist[newurl] ~= true then
        checkvideo(newurl)
      end
    end
    for newurl in string.gmatch(html, 'url="(https?://[^"]+)" blip:role="source"') do
      if downloaded[newurl] ~= true and addedtolist[newurl] ~= true then
        checkvideo(newurl)
      end
    end
    if string.match(url, "showplayer=2014093037100220150422135039") then
      local newurl = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.match(html, "=(.-)\n"), "%%3A", ":"), "%%2F", "/"), "%%3F", "?"), "%%3D", "="), "%%26", "&")
      if downloaded[newurl] ~= true and addedtolist[newurl] ~= true and removedlist[url] ~= true then
        checkvideo(newurl)
      end
    end
    for newurl in string.gmatch(html, 'url="(https?://[^"]+)" blip:role="Blip SD"') do
      local num = 0
      while num < 101 do
        if downloaded[newurl.."?showplayer=2014093037100220150422135039&referrer=http://blip.tv&mask="..num.."&skin=flashvars&view=url"] ~= true and addedtolist[newurl.."?showplayer=2014093037100220150422135039&referrer=http://blip.tv&mask="..num.."&skin=flashvars&view=url"] ~= true then
          table.insert(urls, { url=newurl.."?showplayer=2014093037100220150422135039&referrer=http://blip.tv&mask="..num.."&skin=flashvars&view=url" })
          addedtolist[newurl.."?showplayer=2014093037100220150422135039&referrer=http://blip.tv&mask="..num.."&skin=flashvars&view=url"] = true
        end
        num = num + 1
      end
    end
    for newurl in string.gmatch(html, '"(https?://[^"]+)"') do
      check(newurl)
    end
    for newurl in string.gmatch(html, "'(https?://[^']+)'") do
      check(newurl)
    end
    if string.match(url, "/rss/flash/") then
      for newurl in string.gmatch(html, '>(https?://[^<]+)<') do
        check(newurl)
      end
    end
    for newurl in string.gmatch(html, '("/[^"]+)"') do
      if string.match(newurl, '"//') then
        check(string.gsub(newurl, '"//', 'http://'))
      else
        check(string.match(url, '(https?://[^/]+)/')..string.match(newurl, '"(.+)'))
      end
    end
    for newurl in string.gmatch(html, "('/[^']+)'") do
      if string.match(newurl, "'//") then
        check(string.gsub(newurl, "'//", "http://"))
      else
        check(string.match(url, "(https?://[^/]+)/")..string.match(newurl, "'(.+)"))
      end
    end
  end
  
  return urls
end
  

wget.callbacks.httploop_result = function(url, err, http_stat)
  -- NEW for 2014: Slightly more verbose messages because people keep
  -- complaining that it's not moving or not working
  status_code = http_stat["statcode"]
  
  url_count = url_count + 1
  io.stdout:write(url_count .. "=" .. status_code .. " " .. url["url"] .. ".  \n")
  io.stdout:flush()

  if (status_code >= 200 and status_code <= 399) then
    if string.match(url.url, "https://") then
      local newurl = string.gsub(url.url, "https://", "http://")
      downloaded[newurl] = true
    else
      downloaded[url.url] = true
    end
  end

  if string.match(url["url"], "http://blip%.tv/removed") then
    removed = true
  end

  if removed == true and status_code == 410 then
    removedlist[url["url"]] = true
    return wget.actions.NOTHING
  elseif status_code >= 500 or
    (status_code >= 400 and status_code ~= 404) then

    io.stdout:write("\nServer returned "..http_stat.statcode..". Sleeping.\n")
    io.stdout:flush()

    os.execute("sleep 1")

    tries = tries + 1

    if tries >= 5 then
      io.stdout:write("\nI give up...\n")
      io.stdout:flush()
      tries = 0
      if item_type == 'video' then
        return wget.actions.EXIT
      else
        return wget.actions.ABORT
      end
    else
      return wget.actions.CONTINUE
    end
  elseif status_code == 0 then

    io.stdout:write("\nServer returned "..http_stat.statcode..". Sleeping.\n")
    io.stdout:flush()

    os.execute("sleep 10")
    
    tries = tries + 1

    if tries >= 5 then
      io.stdout:write("\nI give up...\n")
      io.stdout:flush()
      tries = 0
      if item_type == 'video' then
        return wget.actions.EXIT
      else
        return wget.actions.ABORT
      end
    else
      return wget.actions.CONTINUE
    end
  end

  tries = 0

  local sleep_time = 0

  if sleep_time > 0.001 then
    os.execute("sleep " .. sleep_time)
  end

  return wget.actions.NOTHING
end

