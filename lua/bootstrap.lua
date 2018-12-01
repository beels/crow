--- Bootstrap Lua by redefining standard library functions
-- dofile() and print() need hardware specific implementations
-- call this before any other lua code
--
--
-- nb: assert() seems to be broken. failed assert does nothing

print = function(...)
    local printResult = ''
    for _,v in ipairs{...} do
        printResult = printResult .. tostring(v) .. '\t'
    end
    debug_usart(printResult) --TODO replace this with formatted print over USB?
    print_serial(printResult)
end

-- nb: this is basically the inverse of l2h.lua (but we don't want that at RT)
dofile = function( path )
    return c_dofile( luapath_to_cpath( path ))
end

function luapath_to_cpath( path )
    -- string manipulation: 'lua/asl.lua' -> 'lua_asl'
    -- see: l2h.lua for how lua is compiled into c-header files
    return string.gsub
            ( string.sub
                ( path
                , 1
                , string.find(path, '%.')-1
                )
            , '/'
            , '_'
            )
end

print'lua bootstrapped'

crow = dofile('lua/crowlib.lua')

--- Tests
-- move these to a diff file & run tests over all the functions from makefile?

--local function run_tests()
--    -- TODO use load() to abstract the called function
--    local test = [[luapath_to_cpath('lua/asl.lua')]]
--    print('test\t'..test)
--    local expect = 'lua_asl'
--    local result = luapath_to_cpath('lua/asl.lua')
--    if expect ~= result then
--        print('FAILED!'..'\texpect\t'..'lua_asl')
--        print('\tresult\t'..result)
--    else print'ok!' end
--end
--
--run_tests()
