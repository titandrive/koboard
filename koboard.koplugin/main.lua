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

local DEX_B64 = "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aXRvckluZm87AChMYW5kcm9pZC92aWV3L2lucHV0bWV0aG9kL0V4dHJhY3RlZFRleHQ7AC9MYW5kcm9pZC92aWV3L2lucHV0bWV0aG9kL0V4dHJhY3RlZFRleHRSZXF1ZXN0OwAqTGFuZHJvaWQvdmlldy9pbnB1dG1ldGhvZC9JbnB1dENvbm5lY3Rpb247AC1MYW5kcm9pZC92aWV3L2lucHV0bWV0aG9kL0lucHV0TWV0aG9kTWFuYWdlcjsAKUxhbmRyb2lkL3dpZGdldC9GcmFtZUxheW91dCRMYXlvdXRQYXJhbXM7ACNMZGFsdmlrL2Fubm90YXRpb24vRW5jbG9zaW5nTWV0aG9kOwAeTGRhbHZpay9hbm5vdGF0aW9uL0lubmVyQ2xhc3M7AA5MamF2YS9pby9GaWxlOwAUTGphdmEvaW8vRmlsZVdyaXRlcjsAFUxqYXZhL2lvL0lPRXhjZXB0aW9uOwAYTGphdmEvbGFuZy9DaGFyU2VxdWVuY2U7ABBMamF2YS9sYW5nL01hdGg7ABJMamF2YS9sYW5nL09iamVjdDsAFExqYXZhL2xhbmcvUnVubmFibGU7ABJMamF2YS9sYW5nL1N0cmluZzsAGUxqYXZhL2xhbmcvU3RyaW5nQnVpbGRlcjsAIExvcmcva29yZWFkZXIva29ib2FyZC9LT0JvYXJkSUM7ACRMb3JnL2tvcmVhZGVyL2tvYm9hcmQvS09Cb2FyZFNob3ckMTsAIkxvcmcva29yZWFkZXIva29ib2FyZC9LT0JvYXJkU2hvdzsAIkxvcmcva29yZWFkZXIva29ib2FyZC9LT0JvYXJkVmlldzsAAVYAAlZJAANWSUkAAlZMAANWTEwABFZMTEwAA1ZMWgACVloAAVoAA1pJSQACWkwAA1pMSQADWkxMAAFdAAldIGN1cnNvcj0AEV0gc2VsZWN0aW9uU3RhcnQ9AAphY2Nlc3MkMDAwAAthY2Nlc3NGbGFncwAKYWN0aW9uRmlsZQAGYWN0aXZlAAhhY3Rpdml0eQAOYWRkQ29udGVudFZpZXcABmFwcGVuZAAGY2hhckF0AApjbGVhckZvY3VzAAVjbG9zZQAKY29tbWl0VGV4dAARY29tbWl0VGV4dCB0ZXh0PVsACWRlYnVnRmlsZQAVZGVsZXRlU3Vycm91bmRpbmdUZXh0ACFkZWxldGVTdXJyb3VuZGluZ1RleHRJbkNvZGVQb2ludHMACmRlbGV0ZVRleHQADGVkaXRhYmxlVGV4dAALZXh0RmlsZXNEaXIAE2ZpbmlzaENvbXBvc2luZ1RleHQAHmZpbmlzaENvbXBvc2luZ1RleHQgZWRpdGFibGU9WwARZm9yd2FyZERpZmZlcmVuY2UACWdldEFjdGlvbgALZ2V0RWRpdGFibGUAEGdldEV4dHJhY3RlZFRleHQAF2dldEV4dHJhY3RlZFRleHQgZmxhZ3M9AApnZXRLZXlDb2RlAA9nZXRTZWxlY3RlZFRleHQAFmdldFNlbGVjdGVkVGV4dCBmbGFncz0AD2dldFNlbGVjdGlvbkVuZAARZ2V0U2VsZWN0aW9uU3RhcnQAEmdldFRleHRBZnRlckN1cnNvcgAVZ2V0VGV4dEFmdGVyQ3Vyc29yIG49ABNnZXRUZXh0QmVmb3JlQ3Vyc29yABZnZXRUZXh0QmVmb3JlQ3Vyc29yIG49AARoaWRlAAppbWVPcHRpb25zAANpbW0ACWlucHV0VHlwZQARa29ib2FyZF9kZWJ1Zy50eHQADWtvYm9hcmRfaW5wdXQACmxlZnRNYXJnaW4ABmxlbmd0aAADbG9nAANtaW4ABG5hbWUAE29uQ2hlY2tJc1RleHRFZGl0b3IAF29uQ3JlYXRlSW5wdXRDb25uZWN0aW9uABBwYXJ0aWFsRW5kT2Zmc2V0ABJwYXJ0aWFsU3RhcnRPZmZzZXQABHBvc3QADHJlcXVlc3RGb2N1cwADcnVuAAxzZWxlY3Rpb25FbmQADnNlbGVjdGlvblN0YXJ0AAxzZW5kS2V5RXZlbnQACXNldEFjdGl2ZQAQc2V0Q29tcG9zaW5nVGV4dAAXc2V0Q29tcG9zaW5nVGV4dCB0ZXh0PVsADnNldEV4dEZpbGVzRGlyAAxzZXRGb2N1c2FibGUAF3NldEZvY3VzYWJsZUluVG91Y2hNb2RlAA1zZXRWaXNpYmlsaXR5AA1zaG93U29mdElucHV0AAtzdGFydE9mZnNldAAJc3Vic3RyaW5nAAR0ZXh0AAh0b1N0cmluZwAJdG9wTWFyZ2luAAV2YWx1ZQAEdmlldwAFd3JpdGUAmwF+fkQ4eyJiYWNrZW5kIjoiZGV4IiwiY29tcGlsYXRpb24tbW9kZSI6ImRlYnVnIiwiaGFzLWNoZWNrc3VtcyI6ZmFsc2UsIm1pbi1hcGkiOjEsInNoYS0xIjoiNzUwYTIxYjRmNDI4MWIxZjQ1M2I2NDllMGI4NGYxYmE5YzA0ZjRmYyIsInZlcnNpb24iOiI5LjAuMy1kZXYifQACEAGIARo5AhECRQQAcB4AAgYKChIBEiSBgASAHQECwB0EAogeAQLUHAIClBUGArAeJgGgEgEBuBMBAfgTAwG4FAMBoBABAfQZAQHcGgEB2BsCAfAXAQHcGAAAAQE1gIAE+B42AZAfAQMDAQ8KDBIBEgESN4GABOwfAYgg1B8BCZAgOgHAIAACAQQQAgECO4GABKwiPQGUIgEB5CEDAdgiAQHwIgAAAAAAAgAAAJccAACeHAAAQB0AAAAAAAAAAAAAAAAAABAAAAAAAAAAAQAAAAAAAAABAAAAjAAAAHAAAAACAAAAIQAAAKACAAADAAAAJQAAACQDAAAEAAAAEgAAAOAEAAAFAAAARgAAAHAFAAAGAAAABAAAAKAHAAABIAAAGwAAACAIAAADIAAAGwAAAIYRAAABEAAAFgAAALASAAACIAAAjAAAAGQTAAAEIAAAAgAAAJccAAAAIAAABAAAAKYcAAADEAAAAgAAADwdAAAGIAAAAQAAAEwdAAAAEAAAAQAAAFwdAAA="

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
    local jvm = android.app.activity.vm
    local act = android.app.activity.clazz

    local function showIME()
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
            local ctor = env[0].GetMethodID(env, classes.show, "<init>",
                "(Landroid/view/inputmethod/InputMethodManager;Landroid/app/Activity;Ljava/io/File;)V")
            local shower = env[0].NewObject(env, classes.show, ctor, imm, act, ext_file)
            local run_mid = env[0].GetMethodID(env, env[0].GetObjectClass(env, act),
                "runOnUiThread", "(Ljava/lang/Runnable;)V")
            env[0].CallVoidMethod(env, act, run_mid, shower)

            env[0].DeleteLocalRef(env, imm)
            env[0].DeleteLocalRef(env, ext_file)
            env[0].DeleteLocalRef(env, shower)
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

    return showIME, hideIME
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
    local backspace_path = ext_dir .. "/koboard_bs"

    local ok3, showIME, hideIME = pcall(makeIMEFunctions, android, classes)
    if not ok3 then showOverlay("KOBoard: IME setup failed"); return end

    local ok4, VK = pcall(require, "ui/widget/virtualkeyboard")
    local ok5, UIManager = pcall(require, "ui/uimanager")
    if not ok4 then showOverlay("KOBoard: no virtualkeyboard"); return end
    if not ok5 then showOverlay("KOBoard: no UIManager"); return end

    local current_vk = nil
    local kb_active = false
    local original_showKeyboard = VK.showKeyboard
    local original_hideKeyboard = VK.hideKeyboard

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
        local input = io.open(input_path, "r")
        if input then
            local content = input:read("*a")
            input:close()
            local clear = io.open(input_path, "w")
            if clear then clear:close() end
            for line in content:gmatch("[^\n]+") do
                if line == "BS" then
                    deleteChar()
                elseif line:sub(1, 3) == "CH:" then
                    addText(line:sub(4))
                end
            end
        end

        local f = io.open(backspace_path, "r")
        if f then
            f:close()
            pcall(os.remove, backspace_path)
            deleteChar()
        end
        UIManager:scheduleIn(0.05, pollInput)
    end

    function self:hideKOBoardIME()
        if not kb_active and not current_vk then return end
        local vk = current_vk
        kb_active = false
        current_vk = nil
        if vk then vk.visible = false end
        pcall(hideIME)
    end

    VK.showKeyboard = function(vk, ...)
        if not self:isEnabled() then
            return original_showKeyboard(vk, ...)
        end
        if kb_active or vk.visible then return end
        current_vk = vk
        kb_active = true
        vk.visible = true
        local ok, err = pcall(showIME)
        if not ok then showOverlay("KOBoard error: " .. tostring(err)) end
        UIManager:scheduleIn(0.15, pollInput)
    end

    VK.hideKeyboard = function(vk, ...)
        if not kb_active then
            return original_hideKeyboard(vk, ...)
        end
        kb_active = false
        current_vk = nil
        vk.visible = false
        pcall(hideIME)
    end

end

require("koboard_insert_menu")

return KOBoard
