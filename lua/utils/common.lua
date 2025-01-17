local M = {}

function M.make_repeatable_move_pair(forward_move_fn, backward_move_fn)
    local loaded_ts, ts_repeatable
    return function()
        if not loaded_ts then
            loaded_ts,ts_repeatable =
            pcall(require, "nvim-treesitter_textobjects.repeatable_move")
            if loaded_ts then
                forward_move_fn, backward_move_fn =
                ts_repeatable.make_repeatable_move_pair(
                    forward_move_fn, backward_move_fn
                )
            end
        end
        return forward_move_fn()
    end,
        function ()
            if not loaded_ts then
                loaded_ts,ts_repeatable =
                pcall(require, "nvim-treesitter_textobjects.repeatable_move")
                if loaded_ts then
                    forward_move_fn,backward_move_fn =
                    ts_repeatable.make_repeatable_move_pair(
                        forward_move_fn,backward_move_fn
                    )
                end
            end
            return backward_move_fn()
        end
end

return M
