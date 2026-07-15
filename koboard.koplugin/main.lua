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

local DEX_B64 = "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GwAAAAAAAAABAAAAJQAAAAEAAAAHAAAAAgAAAAgAAAACAAAAFwAAAAEAAAAdAAAAAQoAAygpVgABOgAGPGluaXQ+AAFJAANJSUkAAklMAA5LT0JvYXJkSUMuamF2YQAQS09Cb2FyZFNob3cuamF2YQAQS09Cb2FyZFZpZXcuamF2YQABTAACTEkAA0xJSQAETElJTAACTEwAA0xMSQAWTGFuZHJvaWQvYXBwL0FjdGl2aXR5OwAZTGFuZHJvaWQvY29udGVudC9Db250ZXh0OwAXTGFuZHJvaWQvdGV4dC9FZGl0YWJsZTsAGExhbmRyb2lkL3RleHQvU2VsZWN0aW9uOwAYTGFuZHJvaWQvdGV4dC9TcGFubmFibGU7ABVMYW5kcm9pZC91dGlsL0Jhc2U2NDsAF0xhbmRyb2lkL3ZpZXcvS2V5RXZlbnQ7ABNMYW5kcm9pZC92aWV3L1ZpZXc7ACVMYW5kcm9pZC92aWV3L1ZpZXdHcm91cCRMYXlvdXRQYXJhbXM7AC5MYW5kcm9pZC92aWV3L2lucHV0bWV0aG9kL0Jhc2VJbnB1dENvbm5lY3Rpb247ACVMYW5kcm9pZC92aWV3L2lucHV0bWV0aG9kL0VkaXRvckluZm87AChMYW5kcm9pZC92aWV3L2lucHV0bWV0aG9kL0V4dHJhY3RlZFRleHQ7AC9MYW5kcm9pZC92aWV3L2lucHV0bWV0aG9kL0V4dHJhY3RlZFRleHRSZXF1ZXN0OwAqTGFuZHJvaWQvdmlldy9pbnB1dG1ldGhvZC9JbnB1dENvbm5lY3Rpb247AC1MYW5kcm9pZC92aWV3L2lucHV0bWV0aG9kL0lucHV0TWV0aG9kTWFuYWdlcjsAKUxhbmRyb2lkL3dpZGdldC9GcmFtZUxheW91dCRMYXlvdXRQYXJhbXM7ACNMZGFsdmlrL2Fubm90YXRpb24vRW5jbG9zaW5nTWV0aG9kOwAeTGRhbHZpay9hbm5vdGF0aW9uL0lubmVyQ2xhc3M7AB1MZGFsdmlrL2Fubm90YXRpb24vU2lnbmF0dXJlOwAOTGphdmEvaW8vRmlsZTsAFExqYXZhL2lvL0ZpbGVXcml0ZXI7ABVMamF2YS9pby9JT0V4Y2VwdGlvbjsAGExqYXZhL2xhbmcvQ2hhclNlcXVlbmNlOwAQTGphdmEvbGFuZy9NYXRoOwASTGphdmEvbGFuZy9PYmplY3Q7ABRMamF2YS9sYW5nL1J1bm5hYmxlOwASTGphdmEvbGFuZy9TdHJpbmc7ABlMamF2YS9sYW5nL1N0cmluZ0J1aWxkZXI7ABpMamF2YS9uaW8vY2hhcnNldC9DaGFyc2V0OwAjTGphdmEvbmlvL2NoYXJzZXQvU3RhbmRhcmRDaGFyc2V0czsAIExvcmcva29yZWFkZXIva29ib2FyZC9LT0JvYXJkSUM7ACRMb3JnL2tvcmVhZGVyL2tvYm9hcmQvS09Cb2FyZFNob3ckMTsAJExvcmcva29yZWFkZXIva29ib2FyZC9LT0JvYXJkU2hvdyQyOwAiTG9yZy9rb3JlYWRlci9rb2JvYXJkL0tPQm9hcmRTaG93OwAiTG9yZy9rb3JlYWRlci9rb2JvYXJkL0tPQm9hcmRWaWV3OwADU1Q6AAVVVEZfOAABVgACVkkAA1ZJSQACVkwABFZMSUkAA1ZMTAAHVkxMTExJSQADVkxaAAJWWgABWgADWklJAAJaTAADWkxJAAJbQgAKYWNjZXNzJDAwMAALYWNjZXNzRmxhZ3MACmFjdGlvbkZpbGUABmFjdGl2ZQAIYWN0aXZpdHkADmFkZENvbnRlbnRWaWV3AAZhcHBlbmQACmNsZWFyRm9jdXMABWNsb3NlAApjb21taXRUZXh0ABVkZWxldGVTdXJyb3VuZGluZ1RleHQAIWRlbGV0ZVN1cnJvdW5kaW5nVGV4dEluQ29kZVBvaW50cwAKZWRpdG9yVGV4dAAJZW1pdFN0YXRlAA5lbmNvZGVUb1N0cmluZwALZXh0RmlsZXNEaXIAE2ZpbmlzaENvbXBvc2luZ1RleHQACWdldEFjdGlvbgAIZ2V0Qnl0ZXMAC2dldEVkaXRhYmxlABBnZXRFeHRyYWN0ZWRUZXh0AApnZXRLZXlDb2RlAA9nZXRTZWxlY3RlZFRleHQAD2dldFNlbGVjdGlvbkVuZAARZ2V0U2VsZWN0aW9uU3RhcnQAEmdldFRleHRBZnRlckN1cnNvcgATZ2V0VGV4dEJlZm9yZUN1cnNvcgAEaGlkZQAKaW1lT3B0aW9ucwADaW1tAA1pbml0aWFsU2VsRW5kAA9pbml0aWFsU2VsU3RhcnQAD2lucHV0Q29ubmVjdGlvbgAJaW5wdXRUeXBlAA1rb2JvYXJkX2lucHV0AApsZWZ0TWFyZ2luAAZsZW5ndGgAA21heAADbWluAARuYW1lABNvbkNoZWNrSXNUZXh0RWRpdG9yABdvbkNyZWF0ZUlucHV0Q29ubmVjdGlvbgAQcGFydGlhbEVuZE9mZnNldAAScGFydGlhbFN0YXJ0T2Zmc2V0AARwb3N0AAdyZXBsYWNlAAxyZXF1ZXN0Rm9jdXMAA3J1bgAMc2VsZWN0aW9uRW5kAA5zZWxlY3Rpb25TdGFydAAMc2VuZEtleUV2ZW50AAlzZXRBY3RpdmUAEHNldENvbXBvc2luZ1RleHQADnNldEVkaXRvclN0YXRlAA5zZXRFeHRGaWxlc0RpcgAMc2V0Rm9jdXNhYmxlABdzZXRGb2N1c2FibGVJblRvdWNoTW9kZQAMc2V0U2VsZWN0aW9uAA1zZXRWaXNpYmlsaXR5AA1zaG93U29mdElucHV0AAtzdGFydE9mZnNldAANc3luY2hyb25pemluZwAEdGV4dAAIdG9TdHJpbmcACXRvcE1hcmdpbgALdXBkYXRlU3RhdGUAB3ZhbCRlbmQACXZhbCRzdGFydAAIdmFsJHRleHQABXZhbHVlAAR2aWV3AAV3cml0ZQCcAX5+RDh7ImJhY2tlbmQiOiJkZXgiLCJjb21waWxhdGlvbi1tb2RlIjoiZGVidWciLCJoYXMtY2hlY2tzdW1zIjpmYWxzZSwibWluLWFwaSI6MjEsInNoYS0xIjoiZmFjZWRmNDFiYmQyOGI1NjNkMWU5ZTA5YzVmNzJkN2M1Y2E1OThkNSIsInZlcnNpb24iOiI4LjIuMi1kZXYifQACEwGJARwBFwICEQGJARo9AhICRQQAax4CEQGJARo7AAIDDA0SAQIlgYAEjBYBArgWBAKAFycB8BIBAZwTAQHIEwIB9BMCAeQRAQG4FQEB1BUBAfAVAQGUFAEB7BQBAbwYAQGYFQADAQEPkCABkCABkCA1gIAEtBk2AdgZAAABATeAgASEGjgBnBoBBgQBGAoSEgESARIBEgESARI5gYAE+BoBiCDgGgEJqBsCCYwdPAHUGwAGAQUZAgECAQIBAgECAQI+gYAErB5AAZQeAQG4HQMB4B4BAfgeAQGsHwAAAQAAAB0bAAACAAAAJhsAAC0bAAACAAAANRsAAC0bAAAEHAAAAAAAAAEAAAAAAAAANQAAAPwbAAAQHAAAAAAAAAAAAAAAAAAAEAAAAAAAAAABAAAAAAAAAAEAAACNAAAAcAAAAAIAAAAnAAAApAIAAAMAAAAlAAAAQAMAAAQAAAAfAAAA/AQAAAUAAABKAAAA9AUAAAYAAAAFAAAARAgAAAEgAAAeAAAA5AgAAAMgAAAeAAAAwg8AAAEQAAAZAAAA6BAAAAIgAACNAAAAwhEAAAQgAAAEAAAAHRsAAAAgAAAFAAAAPBsAAAMQAAADAAAA/BsAAAYgAAACAAAAHBwAAAAQAAABAAAARBwAAA=="

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
                ext_file, editor_text, selection_start or 0, selection_end or selection_start or 0)
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
                selection_start or 0, selection_end or selection_start or 0)
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
    local backspace_path = ext_dir .. "/koboard_bs"

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
    local last_editor_text = nil
    local last_editor_cursor = nil

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
        local cursor = utf16Offset(inputbox.charlist or {}, inputbox.charpos or 1)
        return text, cursor
    end

    local function rememberEditorState(text, cursor)
        last_editor_text = text
        last_editor_cursor = cursor
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
                else
                    local sel_start, sel_end, encoded = line:match("^ST:(%d+):(%d+):(.*)$")
                    if sel_start then
                        local text = b64decode(encoded)
                        local inputbox = current_vk and current_vk.inputbox
                        if inputbox then
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
        local text, cursor = editorState()
        rememberEditorState(text, cursor)
        local ok, err = pcall(showIME, text, cursor, cursor)
        if not ok then showOverlay("KOBoard error: " .. tostring(err)) end
        UIManager:scheduleIn(0.15, pollInput)
    end

    VK.hideKeyboard = function(vk, ...)
        if not kb_active then
            return original_hideKeyboard(vk, ...)
        end
        kb_active = false
        current_vk = nil
        rememberEditorState(nil, nil)
        vk.visible = false
        pcall(hideIME)
    end

end

require("koboard_insert_menu")

return KOBoard
