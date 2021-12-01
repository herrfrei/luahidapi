package = "LuaHidapi"
version = "1.0.1-1"
source = {
   url = "https://github.com/herrfrei/luahidapi/archive/v1.0.1.zip",
   dir = "luahidapi-1.0.1",
}
description = {
   summary = "Hidapi support for the Lua language",
   detailed = [[
      LuaHidapi is a Lua extension library that exposes USB and Bluetooth
      HID-Class devices with help of the HIDAPI library 
      (https://github.com/libusb/hidapi) to lua.
   ]],
   homepage = "http://luaforge.net/projects/luahidapi/",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1"
}

local function make_plat(plat)
   local defines = {
      unix = {
         "HIDAPI_API=__attribute__((visibility(\"default\")))",
      },
      macosx = {
         "HIDAPI_API=__attribute__((visibility(\"default\")))",
      },
      win32 = {
         "NDEBUG",
         "HIDAPI_API=__declspec(dllexport)",
      },
      mingw32 = {
         "WINVER=0x0501",
         "HIDAPI_API=__declspec(dllexport)",
      }
   }
   local modules = {
      ["luahidapi"] = {
         sources = { "src/luahidapi.c" },
         defines = defines[plat],         
         incdirs = {"src", "3rdparty/hidapi/hidapi" }
      },
   }
   if plat == "unix" then
      modules["luahidapi"].sources[#modules["luahidapi"].sources+1] = "3rdparty/hidapi/linux/hid.c"
      modules["luahidapi"].libraries = { "udev" }
   end
   if plat == "macosx" then
      modules["luahidapi"].sources[#modules["luahidapi"].sources+1] = "3rdparty/hidapi/mac/hid.c"
   end
   if plat == "win32" or plat == "mingw32" then
      modules["luahidapi"].sources[#modules["luahidapi"].sources+1] = "3rdparty/hidapi/windows/hid.c"
      modules["luahidapi"].libraries = { "setupapi" }
   end
   modules["luahidapi"].defines[#modules["luahidapi"].defines+1] = "LUAHIDAPI_VERSION=\"1.0.1\""
   return { modules = modules }
end

build = {
   type = "builtin",
   platforms = {
      unix = make_plat("unix"),
      macosx = make_plat("macosx"),
      win32 = make_plat("win32"),
      mingw32 = make_plat("mingw32")
   },
   copy_directories = { "doc" }
}
