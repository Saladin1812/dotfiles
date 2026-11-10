if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Custom fish greeting / prompt
set fish_greeting
set fish_prompt

# Terminal productivity
starship init fish | source
zoxide init --cmd cd fish | source

# Aliases
alias ls="lsd"
alias nv="nvim"
