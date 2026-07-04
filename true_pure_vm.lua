-- [[ ENCRYPTED NON-LINEAR BLOCK INTERPRETER ]] 

local urkdFyVpmVWHz = {
    _XOR = 77,
    _OP = {156, 2443, 42324, 510345},
    _CONST = {},
    _GRAPH = {},
}

table.insert(urkdFyVpmVWHz._CONST, (function() local s = '' for _, b in ipairs({61, 63, 36, 35, 57}) do s = s .. string.char(bit32.bxor(b, 77)) end return s end)())
table.insert(urkdFyVpmVWHz._CONST, (function() local s = '' for _, b in ipairs({12, 46, 46, 40, 62, 62, 109, 10, 63, 44, 35, 57, 40, 41, 99, 109, 8, 53, 40, 46, 56, 57, 36, 34, 35, 109, 30, 44, 35, 41, 47, 34, 53, 109, 4, 35, 36, 57, 36, 44, 33, 36, 55, 40, 41, 99}) do s = s .. string.char(bit32.bxor(b, 77)) end return s end)())
urkdFyVpmVWHz._GRAPH[2828259] = {{2443, 0, 1}, 7970080}
urkdFyVpmVWHz._GRAPH[7970080] = {{156, 1, 2}, 5055317}
urkdFyVpmVWHz._GRAPH[5055317] = {{42324, 0, 1, 1}, 8954678}
urkdFyVpmVWHz._GRAPH[8954678] = {{510345, 0}, 3938074}
local function bfKtbeqtsmSjNwSrtL()
    local _V = urkdFyVpmVWHz  
    local OP_LOADK, OP_GETGLOB, OP_CALL, OP_RETURN = _V._OP[1], _V._OP[2], _V._OP[3], _V._OP[4]  
      
    local Registers = {}  
    local Graph = _V._GRAPH  
    local Constants = _V._CONST  
    
    local stateRouter = 2828259
    
    while stateRouter and stateRouter ~= 0 do  
        local executionNode = Graph[stateRouter]
        if not executionNode then break end
        
        local instr = executionNode[1]
        local nextState = executionNode[2]
        
        local opcode = instr[1]  
          
        if opcode == OP_LOADK then  
            Registers[instr[2]] = Constants[instr[3]]  
            stateRouter = nextState  
              
        elseif opcode == OP_GETGLOB then  
            local gName = Constants[instr[3]]  
            -- 환경 격리 검증 및 글로벌 바인딩 보정
            Registers[instr[2]] = (getfenv and getfenv()[gName]) or _ENV[gName] or _G[gName] or shared[gName]
            stateRouter = nextState  
              
        elseif opcode == OP_CALL then  
            local fReg = instr[2]  
            local argStart = instr[3]  
            local argCount = instr[4]  
              
            local targetFunc = Registers[fReg]  
            local args = {}  
            for i = 0, argCount - 1 do  
                table.insert(args, Registers[argStart + i])
            end  
              
            if targetFunc then
                local results = { targetFunc(unpack(args)) }  
                Registers[fReg] = results[1]  
            end
            stateRouter = nextState  
              
        elseif opcode == OP_RETURN then  
            local retVal = Registers[instr[2]]  
              
            table.clear(Registers)  
            table.clear(_V._GRAPH)  
            table.clear(_V._CONST)  
            table.clear(_V._OP)  
            table.clear(_V)  
            stateRouter = 0
            return retVal  
        else  
            stateRouter = nil
        end  
    end
end

bfKtbeqtsmSjNwSrtL()
