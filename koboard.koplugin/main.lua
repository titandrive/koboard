local WidgetContainer = require("ui/widget/container/widgetcontainer")
local logger = require("logger")

local KOBoard = WidgetContainer:extend{
    name = "koboard",
    is_doc_only = false,
}

local DEX_B64 = "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bGxiYWNrABRLT0JvYXJkQ2FsbGJhY2suamF2YQAJS09Cb2FyZElDAA5LT0JvYXJkSUMuamF2YQALS09Cb2FyZFNob3cAEEtPQm9hcmRTaG93LmphdmEAEEtPQm9hcmRWaWV3LmphdmEAAUwAAkxJAAJMTAADTExJAANMTEwAAkxaABZMYW5kcm9pZC9hcHAvQWN0aXZpdHk7ABlMYW5kcm9pZC9jb250ZW50L0NvbnRleHQ7ABRMYW5kcm9pZC9vcy9IYW5kbGVyOwATTGFuZHJvaWQvb3MvTG9vcGVyOwASTGFuZHJvaWQvdXRpbC9Mb2c7ACJMYW5kcm9pZC92aWV3L0FjdGlvbk1vZGUkQ2FsbGJhY2s7ABlMYW5kcm9pZC92aWV3L0FjdGlvbk1vZGU7ABdMYW5kcm9pZC92aWV3L0tleUV2ZW50OwATTGFuZHJvaWQvdmlldy9NZW51OwAXTGFuZHJvaWQvdmlldy9NZW51SXRlbTsAGkxhbmRyb2lkL3ZpZXcvTW90aW9uRXZlbnQ7ABpMYW5kcm9pZC92aWV3L1NlYXJjaEV2ZW50OwATTGFuZHJvaWQvdmlldy9WaWV3OwAlTGFuZHJvaWQvdmlldy9WaWV3R3JvdXAkTGF5b3V0UGFyYW1zOwAeTGFuZHJvaWQvdmlldy9XaW5kb3ckQ2FsbGJhY2s7AClMYW5kcm9pZC92aWV3L1dpbmRvd01hbmFnZXIkTGF5b3V0UGFyYW1zOwAvTGFuZHJvaWQvdmlldy9hY2Nlc3NpYmlsaXR5L0FjY2Vzc2liaWxpdHlFdmVudDsALkxhbmRyb2lkL3ZpZXcvaW5wdXRtZXRob2QvQmFzZUlucHV0Q29ubmVjdGlvbjsAJUxhbmRyb2lkL3ZpZXcvaW5wdXRtZXRob2QvRWRpdG9ySW5mbzsAKkxhbmRyb2lkL3ZpZXcvaW5wdXRtZXRob2QvSW5wdXRDb25uZWN0aW9uOwAtTGFuZHJvaWQvdmlldy9pbnB1dG1ldGhvZC9JbnB1dE1ldGhvZE1hbmFnZXI7AClMYW5kcm9pZC93aWRnZXQvRnJhbWVMYXlvdXQkTGF5b3V0UGFyYW1zOwAOTGphdmEvaW8vRmlsZTsAFExqYXZhL2lvL0ZpbGVXcml0ZXI7ABhMamF2YS9sYW5nL0NoYXJTZXF1ZW5jZTsAEUxqYXZhL2xhbmcvQ2xhc3M7ABVMamF2YS9sYW5nL0V4Y2VwdGlvbjsAEkxqYXZhL2xhbmcvT2JqZWN0OwAUTGphdmEvbGFuZy9SdW5uYWJsZTsAEkxqYXZhL2xhbmcvU3RyaW5nOwAZTGphdmEvbGFuZy9TdHJpbmdCdWlsZGVyOwAaTGphdmEvbGFuZy9yZWZsZWN0L01ldGhvZDsAJkxvcmcva29yZWFkZXIva29ib2FyZC9LT0JvYXJkQ2FsbGJhY2s7ACBMb3JnL2tvcmVhZGVyL2tvYm9hcmQvS09Cb2FyZElDOwA8TG9yZy9rb3JlYWRlci9rb2JvYXJkL0tPQm9hcmRTaG93JCRFeHRlcm5hbFN5bnRoZXRpY0xhbWJkYTA7ACJMb3JnL2tvcmVhZGVyL2tvYm9hcmQvS09Cb2FyZFNob3c7ACJMb3JnL2tvcmVhZGVyL2tvYm9hcmQvS09Cb2FyZFZpZXc7AANUQUcAAVYAA1ZJSQADVklMAAJWTAADVkxMAARWTExMAANWTFoAAlZaAAFaAANaSUkAA1pJTAAEWklMTAACWkwAA1pMSQADWkxKABJbTGphdmEvbGFuZy9DbGFzczsAE1tMamF2YS9sYW5nL09iamVjdDsADmFkZENvbnRlbnRWaWV3AAZhcHBlbmQACGFwcGVuZDogAAVjbG9zZQAKY29tbWl0VGV4dAANY3JlYXRlTmV3RmlsZQABZAAVZGVsZXRlU3Vycm91bmRpbmdUZXh0ABpkaXNwYXRjaEdlbmVyaWNNb3Rpb25FdmVudAAQZGlzcGF0Y2hLZXlFdmVudAAXZGlzcGF0Y2hLZXlFdmVudDogY29kZT0AGGRpc3BhdGNoS2V5U2hvcnRjdXRFdmVudAAiZGlzcGF0Y2hQb3B1bGF0ZUFjY2Vzc2liaWxpdHlFdmVudAASZGlzcGF0Y2hUb3VjaEV2ZW50ABZkaXNwYXRjaFRyYWNrYmFsbEV2ZW50AAFlAANmJDAAA2YkMQATZmluaXNoQ29tcG9zaW5nVGV4dAAMZmxhZyB3cml0ZTogAAdmb2N1c0luABtmb2N1c0luIHJlZmxlY3Rpb24gZmFpbGVkOiAAEWZvY3VzSW4gc3VjY2VlZGVkAAlnZXRBY3Rpb24AEWdldERlY2xhcmVkTWV0aG9kABNnZXRFeHRlcm5hbEZpbGVzRGlyAApnZXRLZXlDb2RlAA1nZXRNYWluTG9vcGVyAAppbWVPcHRpb25zAAlpbnB1dFR5cGUABmludm9rZQAEa2V5PQAKa29ib2FyZF9icwANa29ib2FyZF9pbnB1dAAtbGFtYmRhJHJ1biQwJG9yZy1rb3JlYWRlci1rb2JvYXJkLUtPQm9hcmRTaG93AApsZWZ0TWFyZ2luAAZsZW5ndGgAC21BY3Rpb25GaWxlAAdtQWN0aXZlAAltQWN0aXZpdHkADG1FeHRGaWxlc0RpcgAEbUltbQAFbU9yaWcAFG9uQWN0aW9uTW9kZUZpbmlzaGVkABNvbkFjdGlvbk1vZGVTdGFydGVkABJvbkF0dGFjaGVkVG9XaW5kb3cAE29uQ2hlY2tJc1RleHRFZGl0b3IAEG9uQ29udGVudENoYW5nZWQAF29uQ3JlYXRlSW5wdXRDb25uZWN0aW9uABFvbkNyZWF0ZVBhbmVsTWVudQARb25DcmVhdGVQYW5lbFZpZXcAFG9uRGV0YWNoZWRGcm9tV2luZG93ABJvbk1lbnVJdGVtU2VsZWN0ZWQADG9uTWVudU9wZW5lZAANb25QYW5lbENsb3NlZAAOb25QcmVwYXJlUGFuZWwAEW9uU2VhcmNoUmVxdWVzdGVkABlvbldpbmRvd0F0dHJpYnV0ZXNDaGFuZ2VkABRvbldpbmRvd0ZvY3VzQ2hhbmdlZAAab25XaW5kb3dTdGFydGluZ0FjdGlvbk1vZGUAC3Bvc3REZWxheWVkAANydW4ADHNlbmRLZXlFdmVudAANc2V0QWNjZXNzaWJsZQAJc2V0QWN0aXZlABJzZXRDb21wb3NpbmdSZWdpb24AEHNldENvbXBvc2luZ1RleHQADHNldEZvY3VzYWJsZQAXc2V0Rm9jdXNhYmxlSW5Ub3VjaE1vZGUADXNob3dTb2Z0SW5wdXQAFHNob3dTb2Z0SW5wdXQgcG9zdGVkAAh0b1N0cmluZwAJdG9wTWFyZ2luAAF3AAV3cml0ZQCbAX5+RDh7ImJhY2tlbmQiOiJkZXgiLCJjb21waWxhdGlvbi1tb2RlIjoiZGVidWciLCJoYXMtY2hlY2tzdW1zIjpmYWxzZSwibWluLWFwaSI6MSwic2hhLTEiOiI3NTBhMjFiNGY0MjgxYjFmNDUzYjY0OWUwYjg0ZjFiYTljMDRmNGZjIiwidmVyc2lvbiI6IjkuMC4zLWRldiJ9AAEDARgEGgVCARIBEjeBgATwGjgB1BQBAfQUAQGwGAEB0BgBAfAYAQGQGQEBmBsBAbQbAQHQGwEB7BsBAbAZAQG0FAEBiBwBAdAZAQHwGQEBpBwBAZAaAQGwGgEB0BoBAcAcAQHcHAEB9BMBAZQUAQH4HAEBAgYIGgkSUIGABIwfAYKACLgfUgGQHQEB6B0BAZQeAQGoHgEB5B4BAfgeAAIBAQqRIAGRIFiBoATwIFkRkCEBAwECDBoNEgESARJagYAEsCFbgCDUIQEBgCIAAQECEBJdgYAEsCReAZwkAQHsIwEXCwEXDQEXDwAAAAAAAA8AAAAAAAAAAQAAAAAAAAABAAAAmwAAAHAAAAACAAAAKwAAANwCAAADAAAALwAAAIgDAAAEAAAAEQAAALwFAAAFAAAAYgAAAEQGAAAGAAAABQAAAFQJAAABIAAAKQAAAPQJAAADIAAAKQAAAFoSAAABEAAAJgAAAHwTAAACIAAAmwAAALQUAAAAIAAABQAAAMwfAAAFIAAAAwAAAK0gAAADEAAAAQAAALggAAAAEAAAAQAAALwgAAA="

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

local function makeIMEFunctions(android)
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
            -- toggleSoftInput(SHOW_FORCED=2, 0)
            env[0].CallVoidMethod(env, imm,
                env[0].GetMethodID(env, env[0].GetObjectClass(env, imm),
                    "toggleSoftInput", "(II)V"), 2, 0)
            env[0].DeleteLocalRef(env, imm)
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

    local ok3, showIME, hideIME = pcall(makeIMEFunctions, android)
    if not ok3 then showOverlay("KOBoard: IME setup failed"); return end

    local ok4, VK = pcall(require, "ui/widget/virtualkeyboard")
    if not ok4 then showOverlay("KOBoard: no virtualkeyboard"); return end

    VK.showKeyboard = function(self)
        local ok, err = pcall(showIME)
        if not ok then showOverlay("KOBoard error: " .. tostring(err)) end
    end

    VK.hideKeyboard = function(self)
        pcall(hideIME)
    end

    showOverlay("KOBoard: ready")
end

return KOBoard
