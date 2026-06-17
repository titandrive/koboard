local WidgetContainer = require("ui/widget/container/widgetcontainer")
local logger = require("logger")

local KOBoard = WidgetContainer:extend{
    name = "koboard",
    is_doc_only = false,
}

local DEX_B64 = "ZGV4CjAzNQCnyly577y/CKlWqn1rY1RgWlhUBcqitaU0EQAAcAAAAHhWNBIAAAAAAAAAAIgQAABXAAAAcAAAABgAAADMAQAAGAAAACwCAAALAAAATAMAACoAAACkAwAAAwAAAPQEAADgCwAAVAUAADgKAAA6CgAAPQoAAEUKAABJCgAATgoAAFEKAABhCgAAcwoAAIUKAACICgAAjAoAAJEKAACVCgAArQoAAMgKAADhCgAA9goAAB0LAABNCwAAdAsAAKALAADPCwAA+gsAAAoMAAAgDAAANwwAAFEMAABlDAAAewwAAI8MAACqDAAAzAwAAPAMAAAUDQAAFw0AABwNAAAgDQAAJQ0AACsNAAAwDQAANA0AADcNAAA8DQAAQA0AAEUNAABRDQAAWQ0AAGMNAABzDQAAew0AAIYNAACNDQAAmQ0AALANAADTDQAA4A0AAPUNAAAADgAADA4AAB0OAAAxDgAARg4AAEwOAABYDgAAXQ4AAGgOAAB3DgAAgw4AAIsOAACgDgAAuQ4AAMcOAADMDgAA2g4AAOUOAAD3DgAABw8AABUPAAAuDwAAPQ8AAEcPAABYDwAAYw8AAGkPAABwDwAAcw8AAAUAAAANAAAADgAAAA8AAAAQAAAAEQAAABIAAAATAAAAFAAAABUAAAAWAAAAFwAAABgAAAAZAAAAGgAAABsAAAAcAAAAHQAAAB4AAAAfAAAAIAAAACEAAAAiAAAAKQAAAAUAAAAAAAAAAAAAAAwAAAAIAAAArAkAAAoAAAAOAAAAtAkAAAsAAAAOAAAAvAkAAAkAAAARAAAAAAAAAAwAAAASAAAAxAkAACIAAAAWAAAAAAAAACMAAAAWAAAAvAkAACQAAAAWAAAAzAkAACUAAAAWAAAA1AkAACUAAAAWAAAA3AkAACUAAAAWAAAA5AkAACcAAAAWAAAA7AkAACYAAAAWAAAA9AkAACQAAAAWAAAAAAoAACUAAAAWAAAACAoAACcAAAAWAAAAEAoAACQAAAAWAAAAxAkAACgAAAAWAAAAGAoAACkAAAAXAAAAAAAAACoAAAAXAAAAvAkAACsAAAAXAAAAIAoAACwAAAAXAAAAKAoAACwAAAAXAAAAMAoAAAcAAAA/AAAABwAAAEEAAAAKAAAAQwAAAAoAAABSAAAAEwALAC0AAAAUAAEALwAAABQACwA3AAAAFAAJAEAAAAAUABUAUwAAABUAFwAuAAAAFQALADcAAAABAAoAMAAAAAMAAAA5AAAAAwAAADoAAAAEAAgAAgAAAAYADAACAAAABgAVAEkAAAAJABYATwAAAAkABwBRAAAACgAHAAIAAAALAA8AAgAAAAwAEAACAAAADAAGADMAAAAMABEAVAAAAA4AAABEAAAADgAEAFAAAAAPAAYAAgAAABIABgACAAAAEgAFADEAAAASAAQAUAAAABMACwACAAAAEwARADEAAAATABMAMgAAABMAFwA0AAAAEwAUADUAAAATABQANgAAABMAEwA4AAAAEwACADsAAAATAAMAPAAAABMAAwA9AAAAEwAVAEkAAAATABcASwAAABQADQACAAAAFAAGAD4AAAAUAAYASAAAABUACQACAAAAFQATAEUAAAAVAAEARgAAABUAEwBHAAAAFQASAEoAAAAVAA4ATAAAABUAEgBNAAAAFQASAE4AAAATAAAAAQAAAAYAAAAAAAAABgAAAAAAAAAREAAAAAAAABQAAAABAAAADwAAAKQJAAAHAAAAAAAAAEkQAAAAAAAAFQAAAAEAAAAEAAAAAAAAAAgAAAAAAAAAYxAAAAAAAAACAAEAAgAAAAoJAAAHAAAAGgADAHAgFAABABIQDwAAAAQAAwACAAAADwkAACQAAAA4AiIAchANAAIACgM9AxwAIgMSAHAQEAADABoABABuIBEAAwAMA3IQDgACAAwCbiARACMADAJuEBIAAgAMAnAgFAAhABISDwIDAAMAAQAAABkJAAAFAAAAcBAVAAAACgEPAQAAAwADAAEAAAAfCQAABQAAAHAQFQAAAAoBDwEAAAIAAQAAAAAAJQkAAAIAAAASEA8ABAACAAIAAAApCQAAGgAAADgDFQBuEAIAAwAKABMBQwAzEA0AbhABAAMACgA5AAcAcBAVAAIACgMPA28gBQAyAAoDDwMEAAMAAgAAADIJAAAkAAAAOAIiAHIQDQACAAoDPQMcACIDEgBwEBAAAwAaAAQAbiARAAMADANyEA4AAgAMAm4gEQAjAAwCbhASAAIADAJwIBQAIQASEg8CAgACAAAAAAA8CQAAAwAAABoBAAARAQAAAwADAAAAAABBCQAAAwAAABoBAAARAQAAAwADAAAAAABHCQAAAwAAABoBVQARAQAABAADAAMAAABNCQAADgAAABIQcDAEACEAIgILABoAQgBwMAkAMgBbEgQADgAFAAIAAwABAFUJAAAWAAAAIgAMAFQxBAASEnAwCgAQAm4gDABAABoEAQBuIAwAQABuEAsAAAAoAg0EDgAAAAAAEwABAAEBDRQEAAQAAQAAAGAJAAAKAAAAcBAPAAAAWwEHAFsCBQBbAwYADgACAAAAAgAAAGsJAAALAAAAYgAIADgACABiAAgAEgFuICYAEAAOAAAABgABAAMAAABxCQAASwAAAGIACAASARISOQAeACIAFQBUUwUAVFQGAHAwIgAwBGkACAAiAAoAcDAIACACWQECAFkBAwBUUwUAYgQIAG4wAABDACgIYgAIAFRTBgBuICcAMABiAAgAbiAmACAAYgAIAG4gKAAgAGIACABuICkAIABiAAgAbhAlAAAAVFAHAGICCAASI24wBgAgA1RQBwBuMAcAMAEOAAAAAwACAAMAAACDCQAAEgAAABQAAQAKAFkgAQAUAAEAABJZIAAAIgITAFQQCgBwMBMAEgARAgIAAQAAAAAAigkAAAMAAABVEAkADwAAAAMAAwACAAAAjgkAAA0AAABwIAMAEABbAgoAEhFuICgAEABuICkAEAAOAAAAAgACAAAAAACYCQAAAwAAAFwBCQAOAAAAAgACAAAAAACeCQAAAwAAAFsBCgAOAB0ADloAIwIAAA6HARoQADgCAAAOAD0CAAAOADMADgBCAQAOLYdpWwArAgAADocBGhAAUQEADgBWAgAADgBMAgAADgAOAgAADkuWABQBAA6HPFo9HB8ADwMAAAAOPC0tLQAqAA5LagAXAA5ptFotLXgeelpaWlqHWgAkAQAOXFwAHwAOAA8CAAAOPC1LPAAaAQAOLQAWAQAOLQABAAAAEAAAAAEAAAAHAAAAAQAAAAAAAAACAAAAAAAAAAEAAAARAAAAAQAAAAIAAAACAAAAAgALAAIAAAAEAAUAAgAAAAQACwACAAAABAAXAAMAAAAJAAEACwAAAAEAAAALAAAAAgAAAAsAEQACAAAACwAXAAEAAAAXAAAAAQAAAAMAAAACAAAABAAAAAIAAAAOAAAAAAABCgAGPGluaXQ+AAJCUwADQ0g6AAFJAA5LT0JvYXJkSUMuamF2YQAQS09Cb2FyZFNob3cuamF2YQAQS09Cb2FyZFZpZXcuamF2YQABTAACTEkAA0xJSQACTEwAFkxhbmRyb2lkL2FwcC9BY3Rpdml0eTsAGUxhbmRyb2lkL2NvbnRlbnQvQ29udGV4dDsAF0xhbmRyb2lkL3ZpZXcvS2V5RXZlbnQ7ABNMYW5kcm9pZC92aWV3L1ZpZXc7ACVMYW5kcm9pZC92aWV3L1ZpZXdHcm91cCRMYXlvdXRQYXJhbXM7AC5MYW5kcm9pZC92aWV3L2lucHV0bWV0aG9kL0Jhc2VJbnB1dENvbm5lY3Rpb247ACVMYW5kcm9pZC92aWV3L2lucHV0bWV0aG9kL0VkaXRvckluZm87ACpMYW5kcm9pZC92aWV3L2lucHV0bWV0aG9kL0lucHV0Q29ubmVjdGlvbjsALUxhbmRyb2lkL3ZpZXcvaW5wdXRtZXRob2QvSW5wdXRNZXRob2RNYW5hZ2VyOwApTGFuZHJvaWQvd2lkZ2V0L0ZyYW1lTGF5b3V0JExheW91dFBhcmFtczsADkxqYXZhL2lvL0ZpbGU7ABRMamF2YS9pby9GaWxlV3JpdGVyOwAVTGphdmEvaW8vSU9FeGNlcHRpb247ABhMamF2YS9sYW5nL0NoYXJTZXF1ZW5jZTsAEkxqYXZhL2xhbmcvT2JqZWN0OwAUTGphdmEvbGFuZy9SdW5uYWJsZTsAEkxqYXZhL2xhbmcvU3RyaW5nOwAZTGphdmEvbGFuZy9TdHJpbmdCdWlsZGVyOwAgTG9yZy9rb3JlYWRlci9rb2JvYXJkL0tPQm9hcmRJQzsAIkxvcmcva29yZWFkZXIva29ib2FyZC9LT0JvYXJkU2hvdzsAIkxvcmcva29yZWFkZXIva29ib2FyZC9LT0JvYXJkVmlldzsAAVYAA1ZJSQACVkwAA1ZMTAAEVkxMTAADVkxaAAJWWgABWgADWklJAAJaTAADWkxJAAphY3Rpb25GaWxlAAZhY3RpdmUACGFjdGl2aXR5AA5hZGRDb250ZW50VmlldwAGYXBwZW5kAAliYWNrc3BhY2UABWNsb3NlAApjb21taXRUZXh0ABVkZWxldGVTdXJyb3VuZGluZ1RleHQAIWRlbGV0ZVN1cnJvdW5kaW5nVGV4dEluQ29kZVBvaW50cwALZXh0RmlsZXNEaXIAE2ZpbmlzaENvbXBvc2luZ1RleHQACWdldEFjdGlvbgAKZ2V0S2V5Q29kZQAPZ2V0U2VsZWN0ZWRUZXh0ABJnZXRUZXh0QWZ0ZXJDdXJzb3IAE2dldFRleHRCZWZvcmVDdXJzb3IABGhpZGUACmltZU9wdGlvbnMAA2ltbQAJaW5wdXRUeXBlAA1rb2JvYXJkX2lucHV0AApsZWZ0TWFyZ2luAAZsZW5ndGgAE29uQ2hlY2tJc1RleHRFZGl0b3IAF29uQ3JlYXRlSW5wdXRDb25uZWN0aW9uAAxyZXF1ZXN0Rm9jdXMAA3J1bgAMc2VuZEtleUV2ZW50AAlzZXRBY3RpdmUAEHNldENvbXBvc2luZ1RleHQADnNldEV4dEZpbGVzRGlyAAxzZXRGb2N1c2FibGUAF3NldEZvY3VzYWJsZUluVG91Y2hNb2RlAA1zaG93U29mdElucHV0AAh0b1N0cmluZwAPdG9nZ2xlU29mdElucHV0AAl0b3BNYXJnaW4ABHZpZXcABXdyaXRlAAF4AJsBfn5EOHsiYmFja2VuZCI6ImRleCIsImNvbXBpbGF0aW9uLW1vZGUiOiJkZWJ1ZyIsImhhcy1jaGVja3N1bXMiOmZhbHNlLCJtaW4tYXBpIjoxLCJzaGEtMSI6Ijc1MGEyMWI0ZjQyODFiMWY0NTNiNjQ5ZTBiODRmMWJhOWMwNGY0ZmMiLCJ2ZXJzaW9uIjoiOS4wLjMtZGV2In0AAAEDCQQSE4GABPwNAQKoDgEC1AoWAfQKAQHMCwEB6AsBAYQMAQG0DQEBzA0BAeQNAQGYDAEB3AwBAwIBCAoFEgESARIfgYAE8A4BCZQPIQG8DwACAQQJAgECIoGABLARIwGYEQEB5BACAdwRAQH0EQAAAAAAAAAOAAAAAAAAAAEAAAAAAAAAAQAAAFcAAABwAAAAAgAAABgAAADMAQAAAwAAABgAAAAsAgAABAAAAAsAAABMAwAABQAAACoAAACkAwAABgAAAAMAAAD0BAAAASAAABQAAABUBQAAAyAAABQAAAAKCQAAARAAABIAAACkCQAAAiAAAFcAAAA4CgAAACAAAAMAAAAREAAAAxAAAAEAAACEEAAAABAAAAEAAACIEAAA"

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

    showOverlay("KOBoard: loading…")

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
        for ch in text:gmatch(".") do
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
        current_vk = self
        kb_active = true
        local ok, err = pcall(showIME)
        if not ok then showOverlay("KOBoard error: " .. tostring(err)) end
        UIManager:scheduleIn(0.15, pollInput)
    end

    VK.hideKeyboard = function(self)
        kb_active = false
        current_vk = nil
        pcall(hideIME)
    end

    showOverlay("KOBoard: ready")
end

return KOBoard
