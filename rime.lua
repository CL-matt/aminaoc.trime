-- rime.lua
function conlang_filter(input, env)
    local raw_input = env.engine.context.input
    if raw_input == nil or raw_input == "" then
        for cand in input:iter() do yield(cand) end
        return
    end

    local clean_input = string.gsub(raw_input, "'", "")
    local length = string.len(clean_input)
    
    -- 保持底层逻辑为 n-i-h-a-o
    local final_str = clean_input
    
    -- 把最后一个字母大写
    if length > 0 then
        local prefix = string.sub(final_str, 1, length - 1)
        local last_char = string.upper(string.sub(final_str, length, length))
        final_str = prefix .. last_char
    end

    -- 加上 RLO (强制从右向左覆盖) 和 PDF (状态闭合)
    final_str = "\226\128\174" .. final_str .. "\226\128\172"

    for cand in input:iter() do
        local new_cand = Candidate("conlang", cand.start, cand._end, final_str, cand.text)
        yield(new_cand)
    end
end