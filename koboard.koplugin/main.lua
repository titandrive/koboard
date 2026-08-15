local WidgetContainer = require("ui/widget/container/widgetcontainer")
local Dispatcher = require("dispatcher")
local logger = require("logger")
local _ = require("gettext")

local KOBoard = WidgetContainer:extend{
    name = "koboard",
    is_doc_only = false,
}

local SETTINGS_KEY_ENABLED = "koboard_enabled"
local SETTINGS_KEY_CHECK_UPDATES = "koboard_check_updates"

local DEX_B64 = "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AARMSUlMAAJMTAADTExJABZMYW5kcm9pZC9hcHAvQWN0aXZpdHk7ABlMYW5kcm9pZC9jb250ZW50L0NvbnRleHQ7ABhMYW5kcm9pZC9ncmFwaGljcy9Qb2ludDsAF0xhbmRyb2lkL2dyYXBoaWNzL1JlY3Q7ABdMYW5kcm9pZC90ZXh0L0VkaXRhYmxlOwAYTGFuZHJvaWQvdGV4dC9TZWxlY3Rpb247ABhMYW5kcm9pZC90ZXh0L1NwYW5uYWJsZTsAGExhbmRyb2lkL3RleHQvVGV4dFV0aWxzOwAVTGFuZHJvaWQvdXRpbC9CYXNlNjQ7ABZMYW5kcm9pZC92aWV3L0Rpc3BsYXk7ABdMYW5kcm9pZC92aWV3L0tleUV2ZW50OwATTGFuZHJvaWQvdmlldy9WaWV3OwAlTGFuZHJvaWQvdmlldy9WaWV3R3JvdXAkTGF5b3V0UGFyYW1zOwA2TGFuZHJvaWQvdmlldy9WaWV3VHJlZU9ic2VydmVyJE9uR2xvYmFsTGF5b3V0TGlzdGVuZXI7AB9MYW5kcm9pZC92aWV3L1ZpZXdUcmVlT2JzZXJ2ZXI7ABVMYW5kcm9pZC92aWV3L1dpbmRvdzsAHExhbmRyb2lkL3ZpZXcvV2luZG93TWFuYWdlcjsALkxhbmRyb2lkL3ZpZXcvaW5wdXRtZXRob2QvQmFzZUlucHV0Q29ubmVjdGlvbjsAJUxhbmRyb2lkL3ZpZXcvaW5wdXRtZXRob2QvRWRpdG9ySW5mbzsAKExhbmRyb2lkL3ZpZXcvaW5wdXRtZXRob2QvRXh0cmFjdGVkVGV4dDsAL0xhbmRyb2lkL3ZpZXcvaW5wdXRtZXRob2QvRXh0cmFjdGVkVGV4dFJlcXVlc3Q7ACpMYW5kcm9pZC92aWV3L2lucHV0bWV0aG9kL0lucHV0Q29ubmVjdGlvbjsALUxhbmRyb2lkL3ZpZXcvaW5wdXRtZXRob2QvSW5wdXRNZXRob2RNYW5hZ2VyOwApTGFuZHJvaWQvd2lkZ2V0L0ZyYW1lTGF5b3V0JExheW91dFBhcmFtczsAI0xkYWx2aWsvYW5ub3RhdGlvbi9FbmNsb3NpbmdNZXRob2Q7AB5MZGFsdmlrL2Fubm90YXRpb24vSW5uZXJDbGFzczsAJExkYWx2aWsvYW5ub3RhdGlvbi9NZXRob2RQYXJhbWV0ZXJzOwAdTGRhbHZpay9hbm5vdGF0aW9uL1NpZ25hdHVyZTsADkxqYXZhL2lvL0ZpbGU7ABRMamF2YS9pby9GaWxlV3JpdGVyOwAVTGphdmEvaW8vSU9FeGNlcHRpb247ABhMamF2YS9sYW5nL0NoYXJTZXF1ZW5jZTsAE0xqYXZhL2xhbmcvSW50ZWdlcjsAEExqYXZhL2xhbmcvTWF0aDsAEkxqYXZhL2xhbmcvT2JqZWN0OwAUTGphdmEvbGFuZy9SdW5uYWJsZTsAEkxqYXZhL2xhbmcvU3RyaW5nOwAZTGphdmEvbGFuZy9TdHJpbmdCdWlsZGVyOwAaTGphdmEvbmlvL2NoYXJzZXQvQ2hhcnNldDsAI0xqYXZhL25pby9jaGFyc2V0L1N0YW5kYXJkQ2hhcnNldHM7ACBMb3JnL2tvcmVhZGVyL2tvYm9hcmQvS09Cb2FyZElDOwAkTG9yZy9rb3JlYWRlci9rb2JvYXJkL0tPQm9hcmRTaG93JDE7ACRMb3JnL2tvcmVhZGVyL2tvYm9hcmQvS09Cb2FyZFNob3ckMjsAJExvcmcva29yZWFkZXIva29ib2FyZC9LT0JvYXJkU2hvdyQzOwAiTG9yZy9rb3JlYWRlci9rb2JvYXJkL0tPQm9hcmRTaG93OwAiTG9yZy9rb3JlYWRlci9rb2JvYXJkL0tPQm9hcmRWaWV3OwADU1Q6AAVVVEZfOAABVgACVkkAA1ZJSQACVkwAA1ZMSQAEVkxJSQAGVkxJSUlJAANWTEwAB1ZMTExMSUkAA1ZMWgACVloAAVoAA1pJSQACWkwAA1pMSQACW0IACmFjY2VzcyQwMDAACmFjY2VzcyQxMDAACmFjY2VzcyQyMDAAC2FjY2Vzc0ZsYWdzAAphY3Rpb25GaWxlAA5hY3Rpb25UZW1wRmlsZQAGYWN0aXZlAAhhY3Rpdml0eQAOYWRkQ29udGVudFZpZXcAGWFkZE9uR2xvYmFsTGF5b3V0TGlzdGVuZXIABmFwcGVuZAAGYm90dG9tAApjbGVhckZvY3VzAAVjbG9zZQAKY29tbWl0VGV4dAAGZGVsZXRlABVkZWxldGVTdXJyb3VuZGluZ1RleHQAIWRlbGV0ZVN1cnJvdW5kaW5nVGV4dEluQ29kZVBvaW50cwAKZWRpdG9yVGV4dAAJZW1pdFN0YXRlAA5lbmNvZGVUb1N0cmluZwALZXh0RmlsZXNEaXIAE2ZpbmlzaENvbXBvc2luZ1RleHQACWdldEFjdGlvbgAIZ2V0Qnl0ZXMAC2dldENhcHNNb2RlAApnZXRDb250ZXh0ABFnZXRDdXJzb3JDYXBzTW9kZQAMZ2V0RGVjb3JWaWV3ABFnZXREZWZhdWx0RGlzcGxheQALZ2V0RWRpdGFibGUAEGdldEV4dHJhY3RlZFRleHQACmdldEtleUNvZGUAC2dldFJlYWxTaXplAA9nZXRTZWxlY3RlZFRleHQAD2dldFNlbGVjdGlvbkVuZAARZ2V0U2VsZWN0aW9uU3RhcnQAEGdldFN5c3RlbVNlcnZpY2UAEmdldFRleHRBZnRlckN1cnNvcgATZ2V0VGV4dEJlZm9yZUN1cnNvcgATZ2V0Vmlld1RyZWVPYnNlcnZlcgAJZ2V0V2luZG93ABBnZXRXaW5kb3dNYW5hZ2VyABxnZXRXaW5kb3dWaXNpYmxlRGlzcGxheUZyYW1lAARoaWRlAAppbWVPcHRpb25zAANpbW0AD2luaXRpYWxDYXBzTW9kZQANaW5pdGlhbFNlbEVuZAAPaW5pdGlhbFNlbFN0YXJ0AA9pbnB1dENvbm5lY3Rpb24ACWlucHV0VHlwZQAMaW5wdXRfbWV0aG9kAB1pbnN0YWxsS2V5Ym9hcmRIZWlnaHRMaXN0ZW5lcgAOa29ib2FyZF9oZWlnaHQAEmtvYm9hcmRfaGVpZ2h0LnRtcAANa29ib2FyZF9pbnB1dAARa29ib2FyZF9pbnB1dC50bXAACmxhc3RIZWlnaHQADmxheW91dExpc3RlbmVyAApsZWZ0TWFyZ2luAAZsZW5ndGgAA21heAADbWluAARuYW1lAAVuYW1lcwATb25DaGVja0lzVGV4dEVkaXRvcgAXb25DcmVhdGVJbnB1dENvbm5lY3Rpb24ADm9uR2xvYmFsTGF5b3V0ABBwYXJ0aWFsRW5kT2Zmc2V0ABJwYXJ0aWFsU3RhcnRPZmZzZXQABHBvc3QAB3B1Ymxpc2gAFXB1Ymxpc2hLZXlib2FyZEhlaWdodAAIcmVuYW1lVG8AB3JlcGxhY2UADHJlcXVlc3RGb2N1cwADcnVuAAxzZWxlY3Rpb25FbmQADnNlbGVjdGlvblN0YXJ0AAxzZW5kS2V5RXZlbnQACXNldEFjdGl2ZQAQc2V0Q29tcG9zaW5nVGV4dAAOc2V0RWRpdG9yU3RhdGUADnNldEV4dEZpbGVzRGlyAAxzZXRGb2N1c2FibGUAF3NldEZvY3VzYWJsZUluVG91Y2hNb2RlAAxzZXRTZWxlY3Rpb24ADXNldFZpc2liaWxpdHkADXNob3dTb2Z0SW5wdXQAC3N0YXJ0T2Zmc2V0AA1zeW5jaHJvbml6aW5nAAR0ZXh0AAZ0aGlzJDAACHRvU3RyaW5nAAl0b3BNYXJnaW4AD3VwZGF0ZVNlbGVjdGlvbgALdXBkYXRlU3RhdGUAB3ZhbCRlbmQACHZhbCRyb290AAl2YWwkc3RhcnQACHZhbCR0ZXh0AAV2YWx1ZQAEdmlldwAFd3JpdGUAAXkAmwF+fkQ4eyJiYWNrZW5kIjoiZGV4IiwiY29tcGlsYXRpb24tbW9kZSI6ImRlYnVnIiwiaGFzLWNoZWNrc3VtcyI6ZmFsc2UsIm1pbi1hcGkiOjEsInNoYS0xIjoiNzUwYTIxYjRmNDI4MWIxZjQ1M2I2NDllMGI4NGYxYmE5YzA0ZjRmYyIsInZlcnNpb24iOiI5LjAuMy1kZXYifQACGwJWHAJEEIAAJBAQlAEcAh4eAhwBuQEcARcCAhkBuQEaUgIaAlYEAJMBHgIZAbkBGlUCGQG5ARpRAAMDDRASARIBAjaBgAS8HAQC/BwIgoAIuB43AeAYAQGMGQEBuBkCAeQZAQGoGwIB1BcBAegbAQGEHAEBoBwCAYQaAQHcGgEBxB8BAYgbAAMBARMCAZAgAZAgR4CABLwgSAHkIAADAQEWkCABkCABkCBJgIAE5CFKAYgiAAABAUuAgAS0IkwBzCICBggBHQoDChkSARIBEgESAhIBEk2BgATAIwGIIJAjAYgg8CMBiCCoIwEJiCQBArgkAQKIJQIJ4CdUAaAmAAYBBSECAQIBAgECAQIBAlaBgATAKVkBqCkBAZAoAwH0KQEBjCoBAfgqAAAAAAIAAAD+JAAAESUAAAIAAAAaJQAAISUAAAEAAAARJQAAAgAAAColAAAhJQAAAgAAADElAAAhJQAAOCYAAAAAAAABAAAAAAAAAEcAAAAsJgAATCYAAAAAAAABAAAAAAAAAEkAAABEJgAAWCYAAAAAAAAAAAAAAAAAABAAAAAAAAAAAQAAAAAAAAABAAAAvgAAAHAAAAACAAAAMgAAAGgDAAADAAAANwAAADAEAAAEAAAAJwAAAMQGAAAFAAAAYwAAAPwHAAAGAAAABgAAABQLAAABIAAAJQAAANQLAAADIAAAJQAAAI4VAAABEAAAIQAAAAwXAAACIAAAvgAAADIYAAAEIAAABgAAAP4kAAAAIAAABgAAADglAAADEAAABgAAACgmAAAGIAAAAwAAAGQmAAAAEAAAAQAAAKQmAAA="

local function b64decode(s)
    local lut = {}
    for i, c in ipairs({"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9","+","/"}) do
        lut[c] = i - 1
    end
    local out = {}
    for i = 1, #s, 4 do
        local a = lut[s:sub(i,i)] or 0
        local b = lut[s:sub(i+1,i+1)] or 0
        local c_ch = s:sub(i+2,i+2)
        local d_ch = s:sub(i+3,i+3)
        local c = lut[c_ch] or 0
        local d = lut[d_ch] or 0
        out[#out+1] = string.char(a * 4 + math.floor(b / 16))
        if c_ch ~= "=" and c_ch ~= "" then out[#out+1] = string.char((b % 16) * 16 + math.floor(c / 4)) end
        if d_ch ~= "=" and d_ch ~= "" then out[#out+1] = string.char((c % 4) * 64 + d) end
    end
    return table.concat(out)
end

local function writeDex(cache_dir)
    local dex_path = cache_dir .. "/koboard_ic.dex"
    local bytes = b64decode(DEX_B64)
    local f = io.open(dex_path, "wb")
    if not f then logger.warn("KOBoard: cannot write DEX to " .. dex_path); return nil end
    f:write(bytes)
    f:close()
    return dex_path
end

local function showOverlay(msg)
    logger.info(msg)
    local ok1, UIManager   = pcall(require, "ui/uimanager")
    local ok2, InfoMessage = pcall(require, "ui/widget/infomessage")
    if ok1 and ok2 then
        UIManager:show(InfoMessage:new{ text = msg, timeout = 4 })
    end
end

function KOBoard:isEnabled()
    if not G_reader_settings then return true end
    return G_reader_settings:readSetting(SETTINGS_KEY_ENABLED) ~= false
end

function KOBoard:setEnabled(enabled)
    if G_reader_settings then
        G_reader_settings:saveSetting(SETTINGS_KEY_ENABLED, enabled and true or false)
    end
    if not enabled and self.hideKOBoardIME then
        self:hideKOBoardIME()
    end
end

local function koboard_updater()
    return require("koboard_updater")
end

function KOBoard:checkForUpdates()
    koboard_updater().check()
end

function KOBoard:backgroundUpdateCheck()
    if G_reader_settings and G_reader_settings:readSetting(SETTINGS_KEY_CHECK_UPDATES) == false then
        return
    end

    local ok, Notification = pcall(require, "ui/widget/notification")
    if not ok then return end
    koboard_updater().checkBackground(function(ver)
        Notification:notify(_("KOBoard update available: v") .. ver,
            Notification.SOURCE_ALWAYS_SHOW)
    end)
end

function KOBoard:onResume()
    self:backgroundUpdateCheck()
end

function KOBoard:onLeaveStandby()
    self:backgroundUpdateCheck()
end

function KOBoard:updateMenuItems()
    local Updater = koboard_updater()
    return {
        {
            text = _("Notify on wake when update available"),
            checked_func = function()
                if not G_reader_settings then return true end
                return G_reader_settings:readSetting(SETTINGS_KEY_CHECK_UPDATES) ~= false
            end,
            callback = function()
                if not G_reader_settings then return end
                local enabled = G_reader_settings:readSetting(SETTINGS_KEY_CHECK_UPDATES) ~= false
                G_reader_settings:saveSetting(SETTINGS_KEY_CHECK_UPDATES, not enabled)
            end,
        },
        {
            text_func = function()
                local current = Updater.getInstalledVersion()
                local available = Updater.getAvailableUpdate()
                if available then
                    return _("Update available") .. ": v" .. current .. " -> v" .. available
                end
                return _("Installed version") .. ": v" .. current
            end,
            keep_menu_open = true,
            callback = function()
                self:checkForUpdates()
            end,
        },
    }
end

function KOBoard:onDispatcherRegisterActions()
    Dispatcher:registerAction("koboard_enable", {
        category = "none",
        event = "KOBoardEnable",
        title = _("Enable KOBoard"),
        general = true,
    })
    Dispatcher:registerAction("koboard_disable", {
        category = "none",
        event = "KOBoardDisable",
        title = _("Disable KOBoard"),
        general = true,
    })
    Dispatcher:registerAction("koboard_toggle", {
        category = "none",
        event = "KOBoardToggle",
        title = _("Toggle KOBoard"),
        general = true,
    })
end

function KOBoard:onKOBoardEnable()
    self:setEnabled(true)
    return true
end

function KOBoard:onKOBoardDisable()
    self:setEnabled(false)
    return true
end

function KOBoard:onKOBoardToggle()
    self:setEnabled(not self:isEnabled())
    return true
end

function KOBoard:addToMainMenu(menu_items)
    menu_items.koboard = {
        sorting_hint = "tools",
        text = _("KOBoard"),
        sub_item_table_func = function()
            local update_items = self:updateMenuItems()
            return {
                {
                    text = _("Enable KOBoard"),
                    checked_func = function() return self:isEnabled() end,
                    callback = function(touchmenu_instance)
                        self:setEnabled(not self:isEnabled())
                        if touchmenu_instance then touchmenu_instance:updateItems() end
                    end,
                },
                update_items[1],
                update_items[2],
            }
        end,
    }
end

function KOBoard:deletePluginSettings()
    if G_reader_settings then
        G_reader_settings:delSetting(SETTINGS_KEY_ENABLED)
        G_reader_settings:delSetting(SETTINGS_KEY_CHECK_UPDATES)
    end
    return true
end

local function readDebugFile(android)
    -- Read the debug file written by Java
    local ffi = require("ffi")
    local jvm = android.app.activity.vm
    local act = android.app.activity.clazz
    local path
    android.jni:context(jvm, function(jni)
        local env = jni.env
        local dir = env[0].CallObjectMethod(env, act,
            env[0].GetMethodID(env, env[0].GetObjectClass(env, act),
                "getExternalFilesDir", "(Ljava/lang/String;)Ljava/io/File;"), nil)
        if dir == nil then return end
        local jp = env[0].CallObjectMethod(env, dir,
            env[0].GetMethodID(env, env[0].GetObjectClass(env, dir),
                "getAbsolutePath", "()Ljava/lang/String;"))
        local u = env[0].GetStringUTFChars(env, jp, nil)
        path = ffi.string(u) .. "/koboard_debug.txt"
        env[0].ReleaseStringUTFChars(env, jp, u)
    end)
    if not path then return nil end
    local f = io.open(path, "r")
    if not f then return nil end
    local content = f:read("*a")
    f:close()
    -- Clear the file after reading
    local fw = io.open(path, "w"); if fw then fw:close() end
    return content
end

local function getCacheDir(android)
    local ffi = require("ffi")
    local jvm = android.app.activity.vm
    local act = android.app.activity.clazz
    local dir
    android.jni:context(jvm, function(jni)
        local env = jni.env
        local cf = env[0].CallObjectMethod(env, act,
            env[0].GetMethodID(env, env[0].GetObjectClass(env, act),
                "getCacheDir", "()Ljava/io/File;"))
        local jp = env[0].CallObjectMethod(env, cf,
            env[0].GetMethodID(env, env[0].GetObjectClass(env, cf),
                "getAbsolutePath", "()Ljava/lang/String;"))
        local u = env[0].GetStringUTFChars(env, jp, nil)
        dir = ffi.string(u)
        env[0].ReleaseStringUTFChars(env, jp, u)
        env[0].DeleteLocalRef(env, cf)
        env[0].DeleteLocalRef(env, jp)
    end)
    return dir
end

local function loadClasses(android, dex_path)
    local jvm = android.app.activity.vm
    local act = android.app.activity.clazz
    local cache_dir = dex_path:match("(.*)/[^/]+$")
    local opt_dir = cache_dir .. "/koboard_opt"
    os.execute("rm -rf " .. opt_dir .. " && mkdir -p " .. opt_dir)

    return android.jni:context(jvm, function(jni)
        local env = jni.env
        local function jstr(s) return env[0].NewStringUTF(env, s) end

        local dcl_cls  = env[0].FindClass(env, "dalvik/system/DexClassLoader")
        local dcl_ctor = env[0].GetMethodID(env, dcl_cls, "<init>",
            "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/ClassLoader;)V")
        local cl_mid   = env[0].GetMethodID(env, env[0].GetObjectClass(env, act),
            "getClassLoader", "()Ljava/lang/ClassLoader;")
        local parent   = env[0].CallObjectMethod(env, act, cl_mid)

        local jd = jstr(dex_path); local jo = jstr(opt_dir)
        local dcl = env[0].NewObject(env, dcl_cls, dcl_ctor, jd, jo, nil, parent)
        env[0].DeleteLocalRef(env, jd); env[0].DeleteLocalRef(env, jo)
        env[0].DeleteLocalRef(env, parent)
        if dcl == nil then logger.warn("KOBoard: DexClassLoader failed"); return nil end

        local load_mid = env[0].GetMethodID(env, env[0].GetObjectClass(env, dcl),
            "loadClass", "(Ljava/lang/String;)Ljava/lang/Class;")
        local function loadCls(name)
            local jn = jstr(name)
            local c  = env[0].CallObjectMethod(env, dcl, load_mid, jn)
            env[0].DeleteLocalRef(env, jn)
            if c == nil then logger.warn("KOBoard: loadClass failed: " .. name); return nil end
            return env[0].NewGlobalRef(env, c)
        end

        local classes = {
            show = loadCls("org.koreader.koboard.KOBoardShow"),
        }
        env[0].DeleteLocalRef(env, dcl)
        if not classes.show then return nil end
        logger.info("KOBoard: DEX classes loaded")
        return classes
    end)
end

local function getExtFilesDir(android)
    local ffi = require("ffi")
    local jvm = android.app.activity.vm
    local act = android.app.activity.clazz
    local dir
    android.jni:context(jvm, function(jni)
        local env = jni.env
        local d = env[0].CallObjectMethod(env, act,
            env[0].GetMethodID(env, env[0].GetObjectClass(env, act),
                "getExternalFilesDir", "(Ljava/lang/String;)Ljava/io/File;"), nil)
        if d == nil then return end
        local jp = env[0].CallObjectMethod(env, d,
            env[0].GetMethodID(env, env[0].GetObjectClass(env, d),
                "getAbsolutePath", "()Ljava/lang/String;"))
        local u = env[0].GetStringUTFChars(env, jp, nil)
        dir = ffi.string(u)
        env[0].ReleaseStringUTFChars(env, jp, u)
    end)
    return dir
end

local function makeIMEFunctions(android, classes)
    local ffi = require("ffi")
    local jvm = android.app.activity.vm
    local act = android.app.activity.clazz

    local function showIME(text, selection_start, selection_end)
        android.jni:context(jvm, function(jni)
            local env = jni.env
            local function jstr(s) return env[0].NewStringUTF(env, s) end
            local svc = jstr("input_method")
            local imm = jni:callObjectMethod(act, "getSystemService",
                "(Ljava/lang/String;)Ljava/lang/Object;", svc)
            env[0].DeleteLocalRef(env, svc)

            local ext_file = env[0].CallObjectMethod(env, act,
                env[0].GetMethodID(env, env[0].GetObjectClass(env, act),
                    "getExternalFilesDir", "(Ljava/lang/String;)Ljava/io/File;"), nil)
            local editor_text = jstr(text or "")
            local ctor = env[0].GetMethodID(env, classes.show, "<init>",
                "(Landroid/view/inputmethod/InputMethodManager;Landroid/app/Activity;Ljava/io/File;Ljava/lang/String;II)V")
            local shower = env[0].NewObject(env, classes.show, ctor, imm, act,
                ext_file, editor_text,
                ffi.cast("jint", selection_start or 0),
                ffi.cast("jint", selection_end or selection_start or 0))
            local run_mid = env[0].GetMethodID(env, env[0].GetObjectClass(env, act),
                "runOnUiThread", "(Ljava/lang/Runnable;)V")
            env[0].CallVoidMethod(env, act, run_mid, shower)

            env[0].DeleteLocalRef(env, imm)
            env[0].DeleteLocalRef(env, ext_file)
            env[0].DeleteLocalRef(env, editor_text)
            env[0].DeleteLocalRef(env, shower)
        end)
    end

    local function syncIME(text, selection_start, selection_end)
        android.jni:context(jvm, function(jni)
            local env = jni.env
            local editor_text = env[0].NewStringUTF(env, text or "")
            local update = env[0].GetStaticMethodID(env, classes.show,
                "updateState", "(Ljava/lang/String;II)V")
            env[0].CallStaticVoidMethod(env, classes.show, update, editor_text,
                ffi.cast("jint", selection_start or 0),
                ffi.cast("jint", selection_end or selection_start or 0))
            env[0].DeleteLocalRef(env, editor_text)
        end)
    end

    local function hideIME()
        android.jni:context(jvm, function(jni)
            local env = jni.env
            local deactivate = env[0].GetStaticMethodID(env, classes.show,
                "hide", "()V")
            env[0].CallStaticVoidMethod(env, classes.show, deactivate)

            local function jstr(s) return env[0].NewStringUTF(env, s) end
            local win   = jni:callObjectMethod(act, "getWindow", "()Landroid/view/Window;")
            local decor = jni:callObjectMethod(win, "getDecorView", "()Landroid/view/View;")
            local token = jni:callObjectMethod(decor, "getWindowToken", "()Landroid/os/IBinder;")
            local svc   = jstr("input_method")
            local imm   = jni:callObjectMethod(act, "getSystemService",
                "(Ljava/lang/String;)Ljava/lang/Object;", svc)
            env[0].DeleteLocalRef(env, svc)
            jni:callBooleanMethod(imm, "hideSoftInputFromWindow",
                "(Landroid/os/IBinder;I)Z", token, 0)
            env[0].DeleteLocalRef(env, win)
            env[0].DeleteLocalRef(env, decor)
            env[0].DeleteLocalRef(env, token)
            env[0].DeleteLocalRef(env, imm)
        end)
    end

    return showIME, hideIME, syncIME
end

function KOBoard:init()
    self:onDispatcherRegisterActions()
    if self.ui and self.ui.menu then
        self.ui.menu:registerToMainMenu(self)
    end
    self:backgroundUpdateCheck()

    local ok, android = pcall(require, "android")
    if not ok then logger.warn("KOBoard: no android module:", android); return end

    local cache_dir = getCacheDir(android)
    if not cache_dir then showOverlay("KOBoard: no cache dir"); return end

    local dex_path = writeDex(cache_dir)
    if not dex_path then showOverlay("KOBoard: DEX write failed"); return end

    local ok2, classes = pcall(loadClasses, android, dex_path)
    if not ok2 or not classes then showOverlay("KOBoard: DEX load failed"); return end

    local ext_dir = getExtFilesDir(android)
    if not ext_dir then showOverlay("KOBoard: no ext dir"); return end
    local input_path = ext_dir .. "/koboard_input"
    local input_snapshot_path = ext_dir .. "/koboard_input.processing"
    local backspace_path = ext_dir .. "/koboard_bs"
    local keyboard_height_path = ext_dir .. "/koboard_height"

    local ok3, showIME, hideIME, syncIME = pcall(makeIMEFunctions, android, classes)
    if not ok3 then showOverlay("KOBoard: IME setup failed"); return end

    local ok4, VK = pcall(require, "ui/widget/virtualkeyboard")
    local ok5, UIManager = pcall(require, "ui/uimanager")
    if not ok4 then showOverlay("KOBoard: no virtualkeyboard"); return end
    if not ok5 then showOverlay("KOBoard: no UIManager"); return end

    local current_vk = nil
    local kb_active = false
    local original_showKeyboard = VK.showKeyboard
    local original_hideKeyboard = VK.hideKeyboard
    local original_init = VK.init
    local last_editor_text = nil
    local last_editor_cursor = nil
    local last_keyboard_height = nil
    local reserved_keyboard_height = nil

    -- InputDialog recreates its VirtualKeyboard while re-laying itself out.
    -- Carry the measured IME height into that replacement so the resize settles
    -- after one pass instead of repeatedly reverting to the default height.
    VK.init = function(vk, ...)
        original_init(vk, ...)
        if reserved_keyboard_height and vk.dimen
                and reserved_keyboard_height > vk.dimen.h then
            vk.dimen.h = reserved_keyboard_height
        end
    end

    local function utf16Offset(charlist, charpos)
        local offset = 0
        for i = 1, math.min((charpos or 1) - 1, #charlist) do
            offset = offset + (#charlist[i] == 4 and 2 or 1)
        end
        return offset
    end

    local function charPosFromUtf16(text, offset)
        local chars = require("util").splitToChars(text)
        local units = 0
        for i = 1, #chars do
            local next_units = units + (#chars[i] == 4 and 2 or 1)
            if next_units > offset then return i end
            units = next_units
        end
        return #chars + 1
    end

    local function editorState()
        local inputbox = current_vk and current_vk.inputbox
        if not inputbox then return "", 0 end
        local text = inputbox:getText() or ""
        local chars = require("util").splitToChars(text)
        local cursor = utf16Offset(chars, inputbox.charpos or 1)
        return text, cursor
    end

    local function rememberEditorState(text, cursor)
        last_editor_text = text
        last_editor_cursor = cursor
    end

    local function clearPendingInput()
        pcall(os.remove, input_path)
        pcall(os.remove, input_snapshot_path)
        pcall(os.remove, backspace_path)
        pcall(os.remove, keyboard_height_path)
    end

    local function updateKeyboardHeight()
        local height_file = io.open(keyboard_height_path, "r")
        if not height_file then return end
        local height = tonumber(height_file:read("*a"))
        height_file:close()
        if not height or height <= 0 or height == last_keyboard_height then return end

        local vk = current_vk
        if not (vk and vk.dimen) then return end
        last_keyboard_height = height
        -- Ignore navigation-bar insets and keyboards shorter than KOReader's
        -- normal reservation; only an overlap requires a dialog re-layout.
        if height <= vk.dimen.h then return end
        reserved_keyboard_height = height
        vk.dimen.h = height

        -- InputDialog sizes itself from the virtual keyboard dimensions. Although
        -- KOBoard does not draw that keyboard, exposing the Android IME inset here
        -- keeps the dialog and its buttons above the system keyboard.
        local parent = vk.inputbox and vk.inputbox.parent
        if parent and parent.onKeyboardHeightChanged then
            pcall(parent.onKeyboardHeightChanged, parent)
        end
    end

    local function deleteChar()
        if current_vk and current_vk.delChar and pcall(current_vk.delChar, current_vk) then
            return
        end
        if current_vk and current_vk.inputbox and current_vk.inputbox.delChar then
            pcall(current_vk.inputbox.delChar, current_vk.inputbox)
        end
    end

    local function addText(text)
        if not (current_vk and current_vk.addChar) then return end
        for ch in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
            pcall(current_vk.addChar, current_vk, ch)
        end
    end

    local function pollInput()
        if not kb_active then return end
        updateKeyboardHeight()
        -- Claim a complete snapshot before reading it. Java publishes with an
        -- atomic rename, so it can immediately create the next state without
        -- Lua truncating or deleting data that Java is still writing.
        pcall(os.remove, input_snapshot_path)
        local claimed = os.rename(input_path, input_snapshot_path)
        local input = claimed and io.open(input_snapshot_path, "r") or nil
        if input then
            local content = input:read("*a")
            input:close()
            pcall(os.remove, input_snapshot_path)
            for line in content:gmatch("[^\n]+") do
                if line == "BS" then
                    deleteChar()
                elseif line:sub(1, 3) == "CH:" then
                    addText(line:sub(4))
                else
                    local sel_start, sel_end, encoded = line:match("^ST:(%d+):(%d+):(.*)$")
                    if sel_start then
                        local text = b64decode(encoded)
                        local inputbox = current_vk and current_vk.inputbox
                        if inputbox then
                            if text ~= inputbox:getText() then
                                inputbox.is_text_edited = true
                            end
                            inputbox:setText(text, true)
                            local cursor_pos = charPosFromUtf16(text, tonumber(sel_end))
                            inputbox:moveCursorToCharPos(cursor_pos)
                            rememberEditorState(text, tonumber(sel_end))
                        end
                    end
                end
            end
        end

        local f = io.open(backspace_path, "r")
        if f then
            f:close()
            pcall(os.remove, backspace_path)
            deleteChar()
        end

        local text, cursor = editorState()
        if text ~= last_editor_text or cursor ~= last_editor_cursor then
            rememberEditorState(text, cursor)
            pcall(syncIME, text, cursor, cursor)
        end
        UIManager:scheduleIn(0.05, pollInput)
    end

    function self:hideKOBoardIME()
        if not kb_active and not current_vk then return end
        local vk = current_vk
        kb_active = false
        current_vk = nil
        rememberEditorState(nil, nil)
        last_keyboard_height = nil
        clearPendingInput()
        if vk then vk.visible = false end
        pcall(hideIME)
    end

    VK.showKeyboard = function(vk, ...)
        if not self:isEnabled() then
            return original_showKeyboard(vk, ...)
        end
        if kb_active and current_vk == vk then
            local text, cursor = editorState()
            rememberEditorState(text, cursor)
            local ok, err = pcall(showIME, text, cursor, cursor)
            if not ok then showOverlay("KOBoard error: " .. tostring(err)) end
            return
        end
        if kb_active or vk.visible then return end
        -- A final IME update may arrive while the previous editor is closing.
        -- Do not let that stale snapshot overwrite this editor's initial text.
        clearPendingInput()
        current_vk = vk
        kb_active = true
        vk.visible = true
        -- InputText opens its keyboard before applying the cursor position from
        -- the tap that opened it. Defer showing the IME until that tap handler
        -- has finished so Android receives the final KOReader cursor position.
        UIManager:scheduleIn(0.05, function()
            if not kb_active or current_vk ~= vk then return end
            local text, cursor = editorState()
            rememberEditorState(text, cursor)
            local ok, err = pcall(showIME, text, cursor, cursor)
            if not ok then showOverlay("KOBoard error: " .. tostring(err)) end
        end)
        UIManager:scheduleIn(0.15, pollInput)
    end

    VK.hideKeyboard = function(vk, ...)
        if not kb_active then
            return original_hideKeyboard(vk, ...)
        end
        kb_active = false
        current_vk = nil
        rememberEditorState(nil, nil)
        last_keyboard_height = nil
        clearPendingInput()
        vk.visible = false
        pcall(hideIME)
    end

end

require("koboard_insert_menu")

return KOBoard
