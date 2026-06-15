widget = {
    plugin = 'timer',
    opts = {period = 0},
    cb = function()
        -- Change ' | ' to your desired separator symbol (e.g., ' • ', ' — ')
        return {full_text = '∼', color = '#718ba6'} 
    end,
}
