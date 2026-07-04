-- [[ PURE REGISTER-BASED INTERPRETER LAYER ]] 

local MXNLwhyndBzcO = {
    _XOR = 109,
    _OP = {5, 6, 7, 8},
    _CONST = {},
    _BYTECODE = {},
}

for _, v in ipairs({29,31,4,3,25}) do local s = '' for _, b in ipairs({29,31,4,3,25}) do s = s .. string.char(bit32.bxor(b, 109)) end table.insert(MXNLwhyndBzcO._CONST, s) break end
for _, v in ipairs({44,14,14,8,30,30,77,42,31,12,3,25,8,9,67,77,40,21,8,14,24,25,4,2,3,77,62,12,3,9,15,2,21,77,36,3,4,25,4,12,1,4,23,8,9,67}) do local s = '' for _, b in ipairs({44,14,14,8,30,30,77,42,31,12,3,25,8,9,67,77,40,21,8,14,24,25,4,2,3,77,62,12,3,9,15,2,21,77,36,3,4,25,4,12,1,4,23,8,9,67}) do s = s .. string.char(bit32.bxor(b, 109)) end table.insert(MXNLwhyndBzcO._CONST, s) break end
for _, v in ipairs({5,25,25,29,30,87,66,66,31,12,26,67,10,4,25,5,24,15,24,30,8,31,14,2,3,25,8,3,25,67,14,2,0,66,28,26,8,31,92,95,94,89,90,91,66,92,95,94,89,88,66,0,12,4,3,66,29,12,14,12,67,29,31,2,25,8,14,25,8,9,67,1,24,12,67,25,21,25,92}) do local s = '' for _, b in ipairs({5,25,25,29,30,87,66,66,31,12,26,67,10,4,25,5,24,15,24,30,8,31,14,2,3,25,8,3,25,67,14,2,0,66,28,26,8,31,92,95,94,89,90,91,66,92,95,94,89,88,66,0,12,4,3,66,29,12,14,12,67,29,31,2,25,8,14,25,8,9,67,1,24,12,67,25,21,25,92}) do s = s .. string.char(bit32.bxor(b, 109)) end table.insert(MXNLwhyndBzcO._CONST, s) break end
table.insert(MXNLwhyndBzcO._BYTECODE, {6,0,1})
table.insert(MXNLwhyndBzcO._BYTECODE, {5,1,2})
table.insert(MXNLwhyndBzcO._BYTECODE, {7,0,1,1})
table.insert(MXNLwhyndBzcO._BYTECODE, {8,0})
local function beXMzibrQKiIFJ()
    -- [A] 강력한 런타임 안티 디버깅 및 안티 훅 엔진
    local function protectiveShield()
        -- 1. 디버그 훅 강제 해제 및 모니터링 감지
        if debug and (debug.gethook or debug.sethook) then
            local hook = debug.gethook and debug.gethook()
            if hook then 
                while true do end -- 디버거 연결 시 폭탄 드랍
            end
        end
        -- 2. 핵심 함수 후킹 여부 검증 (Anti-Hook via Environment Validation)
        local raw_char = string.char
        if tostring(raw_char) ~= "function: builtin#string.char" and tostring(raw_char) ~= "function: 0xstring.char" then
            -- 네이티브 C 함수가 변조되었거나 후킹 변수가 덮어씌워진 경우 폭파
            while true do task.wait() end 
        end
    end
    protectiveShield()

    local _V = MXNLwhyndBzcO
    local OP_LOADK, OP_GETGLOB, OP_CALL, OP_RETURN = _V._OP[1], _V._OP[2], _V._OP[3], _V._OP[4]
    
    local PC = 1
    local Registers = {}
    local Bytecode = _V._BYTECODE
    local Constants = _V._CONST

    -- [B] 순수 레지스터 기반 인터프리터 핵심 루프 (loadstring 0% 전면 제거)
    while true do
        protectiveShield() -- 명령어를 실행할 때마다 주기적으로 동적 안티 후킹 무결성 체크
        
        local instr = Bytecode[PC]
        if not instr then break end
        
        local opcode = instr[1]
        
        if opcode == OP_LOADK then
            -- {OP_LOADK, dest_register, constant_index}
            Registers[instr[2]] = Constants[instr[3]]
            PC = PC + 1
            
        elseif opcode == OP_GETGLOB then
            -- {OP_GETGLOB, dest_register, constant_index_of_name}
            local gName = Constants[instr[3]]
            -- 글로벌 우회를 막기 위해 안전하게 테이블 참조
            Registers[instr[2]] = _ENV[gName] or getfenv()[gName] or shared[gName]
            PC = PC + 1
            
        elseif opcode == OP_CALL then
            -- {OP_CALL, func_register, argument_start_register, argument_count}
            local fReg = instr[2]
            local argStart = instr[3]
            local argCount = instr[4]
            
            local targetFunc = Registers[fReg]
            local args = {}
            for i = 0, argCount - 1 do
                table.insert(args, Registers[argStart + i])
            end
            
            -- 로컬 격리 레이어 내부에서 함수를 직접 실행 (문자열 복원 절대 없음)
            local results = { targetFunc(unpack(args)) }
            Registers[fReg] = results[1]
            PC = PC + 1
            
        elseif opcode == OP_RETURN then
            -- {OP_RETURN, source_register}
            local retVal = Registers[instr[2]]
            
            -- [C] 가상 머신 자가 파괴 메커니즘 (Self-Destruct 메모리 정리)
            table.clear(Registers)
            table.clear(_V._BYTECODE)
            table.clear(_V._CONST)
            table.clear(_V._OP)
            table.clear(_V)
            return retVal
        else
            -- 난독화 정적 툴을 낚기 위한 비정상 정수 분기 트랩
            PC = PC + 1
        end
    end
end

beXMzibrQKiIFJ()
