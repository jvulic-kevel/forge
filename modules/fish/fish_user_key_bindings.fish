function fish_user_key_bindings
    fish_vi_key_bindings
    fzf_configure_bindings

    # Enable Ctrl+Backspace and Ctrl+Left/Right in insert mode.
    bind -M insert \e\x7f backward-kill-word
    bind -M insert \e\b backward-kill-word
    bind -M insert \e\[1\;5D backward-word
    bind -M insert \e\[1\;5C forward-word

    bind y fish_clipboard_copy
    bind p fish_clipboard_paste
end
