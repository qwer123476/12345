-- [[ PURE VIRTUAL MACHINE ]] 
local ZBSjooXoioD = {
    _K = {135, 5},
    _CONST = {},
    _PROTO = {},
    ddSAQCNgQQYowo = {},
    sHfkRPDBLIVTo = {},
    _ENV = setmetatable({}, {__index = _G}),
}

ZBSjooXoioD._CONST[1] = {0xf7,0xf5,0xee,0xe9,0xf3}
ZBSjooXoioD._CONST[2] = {0xc6,0xd7,0xa7,0xc1,0xd3,0xc6,0xd7,0xa7,0xd4,0xe4,0xf5,0xee,0xf7,0xf3,0xa7,0x6b,0x0c,0x1b,0x6b,0x19,0x16,0xa7,0xaa,0xa7,0x6b,0x03,0x23,0x6b,0x27,0x12,0xa7,0x6b,0x27,0x07,0x6b,0x19,0x22,0xa7,0x6a,0x1e,0x1b,0x6b,0x03,0x36,0x6a,0x1e,0x13}
ZBSjooXoioD._CONST[3] = {0xf0,0xe6,0xf5,0xe9}
ZBSjooXoioD._CONST[4] = {0xc4,0xef,0xe2,0xe4,0xec,0xc5,0xeb,0xe8,0xe5,0xbd,0xa7}
ZBSjooXoioD._CONST[5] = {0xd7,0xeb,0xe2,0xe6,0xf4,0xe2,0xa7,0xe2,0xe9,0xf3,0xe2,0xf5,0xa7,0xe6,0xa7,0xf1,0xe6,0xeb,0xee,0xe3,0xa7,0xe9,0xf2,0xea,0xe5,0xe2,0xf5,0xa6}
for _, v in ipairs({4608,4288,4544,4256,5408,4608,4224,4544,4192,5408,4608,4224,4544,4160,5408}) do table.insert(ZBSjooXoioD._PROTO, v) end
local function biBHnimeZJUcbFU()
    print("[VM Runtime] 순수 가상 머신 구동 인터프리터 루프 시작...")
    local EDVmzEvrJc = 1
    local maxPC = #ZBSjooXoioD._PROTO
    
    local O_LOADK = 9
    local O_GETG = 23
    local O_CALL = 46
    
    local count = 0
    while EDVmzEvrJc <= maxPC do
        local encOp = ZBSjooXoioD._PROTO[EDVmzEvrJc]
        if encOp then
            local op = bit32.rrotate(encOp, ZBSjooXoioD._K[2])
            op = bit32.bxor(op, ZBSjooXoioD._K[1])
            
            if op == O_GETG then
                EDVmzEvrJc = EDVmzEvrJc + 1
                local cIdx = ZBSjooXoioD._PROTO[EDVmzEvrJc]
                if cIdx then
                    cIdx = bit32.bxor(bit32.rrotate(cIdx, ZBSjooXoioD._K[2]), ZBSjooXoioD._K[1])
                    local cData = ZBSjooXoioD._CONST[cIdx]
                    if cData then
                        local chars = {}
                        for idx, b in ipairs(cData) do chars[idx] = string.char(bit32.bxor(b, ZBSjooXoioD._K[1])) end
                        table.insert(ZBSjooXoioD.ddSAQCNgQQYowo, _G[table.concat(chars)])
                    end
                end
            elseif op == O_LOADK then
                EDVmzEvrJc = EDVmzEvrJc + 1
                local cIdx = ZBSjooXoioD._PROTO[EDVmzEvrJc]
                if cIdx then
                    cIdx = bit32.bxor(bit32.rrotate(cIdx, ZBSjooXoioD._K[2]), ZBSjooXoioD._K[1])
                    local cData = ZBSjooXoioD._CONST[cIdx]
                    if cData then
                        local chars = {}
                        for idx, b in ipairs(cData) do chars[idx] = string.char(bit32.bxor(b, ZBSjooXoioD._K[1])) end
                        table.insert(ZBSjooXoioD.ddSAQCNgQQYowo, table.concat(chars))
                    end
                end
            elseif op == O_CALL then
                local sLen = #ZBSjooXoioD.ddSAQCNgQQYowo
                if sLen >= 2 then
                    local arg = table.remove(ZBSjooXoioD.ddSAQCNgQQYowo)
                    local func = table.remove(ZBSjooXoioD.ddSAQCNgQQYowo)
                    if type(func) == "function" then
                        count = count + 1
                        pcall(func, arg)
                    end
                end
            end
        end
        EDVmzEvrJc = EDVmzEvrJc + 1
    end
    print("[VM Runtime] 가상 연산 무결점 종료. 총 호출 횟수: " .. count)
end
biBHnimeZJUcbFU()
