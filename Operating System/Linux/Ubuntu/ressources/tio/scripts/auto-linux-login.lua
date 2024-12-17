--[[ Session names and associated logins --]]
local logins = {
    ["foo"] = {
        username = "foouser",
        password = "foopass",
    },
    ["bar"] = {
        username = "baruser",
        password = "barpass",
    },
    ["baz"] = {
        username = "bazuser",
        password = "bazpass",
    },
}

--[[ Send a line-break to restart login prompt if needed --]]
write("\n")

--[[ Search login prompt and keep user name thanks to "w+" word regex syntax --]]
local found, match_str = expect("\\w+ login:", 500)
if (1 == found) then
    local hostname = string.match(match_str, "^%w+")
    local login = logins[hostname]
    if (nil ~= login) then
        write(login.username .. "\n")
        expect("Password:")
        write(login.password .. "\n")
    else
        io.write("\r\nDon't know login info for [" .. hostname .. "]\r\n")
    end
end