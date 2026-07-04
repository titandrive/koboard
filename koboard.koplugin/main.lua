local WidgetContainer = require("ui/widget/container/widgetcontainer")
local logger = require("logger")

local KOBoard = WidgetContainer:extend{
    name = "koboard",
    is_doc_only = false,
}

local DEX_B64 = "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dmlldy9WaWV3OwAlTGFuZHJvaWQvdmlldy9WaWV3R3JvdXAkTGF5b3V0UGFyYW1zOwAuTGFuZHJvaWQvdmlldy9pbnB1dG1ldGhvZC9CYXNlSW5wdXRDb25uZWN0aW9uOwAlTGFuZHJvaWQvdmlldy9pbnB1dG1ldGhvZC9FZGl0b3JJbmZvOwAqTGFuZHJvaWQvdmlldy9pbnB1dG1ldGhvZC9JbnB1dENvbm5lY3Rpb247AC1MYW5kcm9pZC92aWV3L2lucHV0bWV0aG9kL0lucHV0TWV0aG9kTWFuYWdlcjsAKUxhbmRyb2lkL3dpZGdldC9GcmFtZUxheW91dCRMYXlvdXRQYXJhbXM7ACNMZGFsdmlrL2Fubm90YXRpb24vRW5jbG9zaW5nTWV0aG9kOwAeTGRhbHZpay9hbm5vdGF0aW9uL0lubmVyQ2xhc3M7AA5MamF2YS9pby9GaWxlOwAUTGphdmEvaW8vRmlsZVdyaXRlcjsAFUxqYXZhL2lvL0lPRXhjZXB0aW9uOwAYTGphdmEvbGFuZy9DaGFyU2VxdWVuY2U7ABBMamF2YS9sYW5nL01hdGg7ABJMamF2YS9sYW5nL09iamVjdDsAFExqYXZhL2xhbmcvUnVubmFibGU7ABJMamF2YS9sYW5nL1N0cmluZzsAGUxqYXZhL2xhbmcvU3RyaW5nQnVpbGRlcjsAIExvcmcva29yZWFkZXIva29ib2FyZC9LT0JvYXJkSUM7ACRMb3JnL2tvcmVhZGVyL2tvYm9hcmQvS09Cb2FyZFNob3ckMTsAIkxvcmcva29yZWFkZXIva29ib2FyZC9LT0JvYXJkU2hvdzsAIkxvcmcva29yZWFkZXIva29ib2FyZC9LT0JvYXJkVmlldzsAAVYAAlZJAANWSUkAAlZMAANWTEwABFZMTEwAA1ZMWgACVloAAVoAA1pJSQACWkwAA1pMSQADWkxMAAphY2Nlc3MkMDAwAAthY2Nlc3NGbGFncwAKYWN0aW9uRmlsZQAGYWN0aXZlAAhhY3Rpdml0eQAOYWRkQ29udGVudFZpZXcABmFwcGVuZAAGY2hhckF0AApjbGVhckZvY3VzAAVjbG9zZQAKY29tbWl0VGV4dAAVZGVsZXRlU3Vycm91bmRpbmdUZXh0ACFkZWxldGVTdXJyb3VuZGluZ1RleHRJbkNvZGVQb2ludHMACmRlbGV0ZVRleHQADGVkaXRhYmxlVGV4dAALZXh0RmlsZXNEaXIAE2ZpbmlzaENvbXBvc2luZ1RleHQAEWZvcndhcmREaWZmZXJlbmNlAAlnZXRBY3Rpb24AC2dldEVkaXRhYmxlAApnZXRLZXlDb2RlAARoaWRlAAppbWVPcHRpb25zAANpbW0ACWlucHV0VHlwZQANa29ib2FyZF9pbnB1dAAKbGVmdE1hcmdpbgAGbGVuZ3RoAANtaW4ABG5hbWUAE29uQ2hlY2tJc1RleHRFZGl0b3IAF29uQ3JlYXRlSW5wdXRDb25uZWN0aW9uAARwb3N0AAxyZXF1ZXN0Rm9jdXMAA3J1bgAMc2VuZEtleUV2ZW50AAlzZXRBY3RpdmUAEHNldENvbXBvc2luZ1RleHQADnNldEV4dEZpbGVzRGlyAAxzZXRGb2N1c2FibGUAF3NldEZvY3VzYWJsZUluVG91Y2hNb2RlAA1zZXRWaXNpYmlsaXR5AA1zaG93U29mdElucHV0AAlzdWJzdHJpbmcACHRvU3RyaW5nAAl0b3BNYXJnaW4ABXZhbHVlAAR2aWV3AAV3cml0ZQCbAX5+RDh7ImJhY2tlbmQiOiJkZXgiLCJjb21waWxhdGlvbi1tb2RlIjoiZGVidWciLCJoYXMtY2hlY2tzdW1zIjpmYWxzZSwibWluLWFwaSI6MSwic2hhLTEiOiI3NTBhMjFiNGY0MjgxYjFmNDUzYjY0OWUwYjg0ZjFiYTljMDRmNGZjIiwidmVyc2lvbiI6IjkuMC4zLWRldiJ9AAINAWQaKgIOAjcEAFMeAAEFBgQSGoGABKwSAQLYEgQCoBMBAoASAgLMDhwBgA0BAbANAQHwDQMBsA4DAeQQAQHQEQAAAQEmgIAEyBMnAeATAQMDAQgKBRIBEgESKIGABLwUAYggpBQBCeAUKwGQFQACAQQJAgECLIGABIAXLgHoFgEBtBYDAawXAQHEFwAAAAAAAAACAAAA/BMAAAIUAACQFAAAAAAAAAAAAAAAAAAAEAAAAAAAAAABAAAAAAAAAAEAAABoAAAAcAAAAAIAAAAeAAAAEAIAAAMAAAAeAAAAiAIAAAQAAAALAAAA8AMAAAUAAAA3AAAASAQAAAYAAAAEAAAAAAYAAAEgAAAWAAAAgAYAAAMgAAAWAAAA2gsAAAEQAAATAAAAoAwAAAIgAABoAAAAPA0AAAQgAAACAAAA/BMAAAAgAAAEAAAAChQAAAMQAAACAAAAjBQAAAYgAAABAAAAnBQAAAAQAAABAAAArBQAAA=="

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

    VK.showKeyboard = function(self)
        if kb_active or self.visible then return end
        current_vk = self
        kb_active = true
        self.visible = true
        local ok, err = pcall(showIME)
        if not ok then showOverlay("KOBoard error: " .. tostring(err)) end
        UIManager:scheduleIn(0.15, pollInput)
    end

    VK.hideKeyboard = function(self)
        if not kb_active and not self.visible then return end
        kb_active = false
        current_vk = nil
        self.visible = false
        pcall(hideIME)
    end

end

return KOBoard
