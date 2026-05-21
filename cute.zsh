# Colors
autoload -U colors && colors

# History file
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY

# Clear history
history-c() {
    : > ~/.zsh_history
    fc -p ~/.zsh_history
}

# Remove failed command
remove_failed_history() {
    if [[ $? -ne 0 ]]; then

        sed -i '$d' ~/.zsh_history

        fc -p ~/.zsh_history
    fi
}

# Prompt 🌸
set_prompt() {

    LAST_STATUS=$?

    if [[ $LAST_STATUS -eq 0 ]]; then
        stat="%B%F{green}(✓)%f%b"
    else
        stat="%B%F{red}(✘)%f%b"
    fi

    PROMPT=$'\n'"%F{183}╭──────────── ♡ ───── ♡ ${stat}%f"$'\n'"%F{183}│%f %F{111}%*%f %B%F{213}❮ __NAME1__ ღ __NAME2__ ❯%f%b"$'\n'"%F{183}╰────────────────────────%f%F{117}➜%f  "
}

# Plugins
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Plugins style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6C6C6C'
ZSH_HIGHLIGHT_STYLES[command]='fg=#FF69B4,bold'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF0000,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=#98FB98'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#FF69B4,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#00FFFF'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#C792EA,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#FFB07C,bold'

# Execution
precmd_functions+=(remove_failed_history)
precmd_functions+=(set_prompt)


# Aliases
alias weather='curl -L -s "wttr.in" | lolcat && echo ""'
alias ls='eza --icons --group-directories-first'
alias cat='batcat'

# Modified Commands
help() {
    count=0

    width=$COLUMNS
    half=$(( (width - 8) / 2 ))
    left_line=$(printf '─%.0s' $(seq 1 $half))
    right_line=$(printf '─%.0s' $(seq 1 $half))

    center_align() {
        local text="$1"
        local width="$2"
        local text_length=${#text}
        local left_padding=$(( (width - text_length) / 2 ))

        printf "%*s%s%*s" \
            "$left_padding" "" \
            "$text" \
            "$(( width - left_padding - text_length ))" ""
    }

    output=$(tldr --platform linux "$@" 2>/dev/null)
    exit_code=$?

    if [[ $exit_code -ne 0 ]]; then
        print -P "%B%F{red}Wrong Command%f%b"
        return 1
    fi

    echo "$output" | while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        ((count++))

        if [[ $count -eq 1 ]]; then
            line="${line#"${line%%[![:space:]]*}"}"
            line="${line%"${line##*[![:space:]]}"}"
            echo
            print -P "%B%F{213}Command : %F{111}$line%f%b"
            echo

        elif [[ $count -eq 2 ]]; then
            line="${line#"${line%%[![:space:]]*}"}"
            line="${line%"${line##*[![:space:]]}"}"
            print -P "%B%F{147}Description : %f%b%F{252}$line%f"
            echo

            print -P "%F{183} ╭${left_line}╮%f  %F{183}╭${right_line}╮%f"
            left_heading=$(center_align "Example" "$half")
            right_heading=$(center_align "Description" "$half")
            print -P "%F{183} │%f%F{225}${left_heading}%f%F{183}│%f  %F{183}│%f%F{225}${right_heading}%f%F{183}│%f"
            print -P "%F{183} ╰${left_line}╯%f  %F{183}╰${right_line}╯%f"

            print -P "%F{183} ╭${left_line}╮%f  %F{183}╭${right_line}╮%f"

        elif [[ "$line" == "  - "* ]]; then
            left="${line%%:*}"
            left="${left#  - }"
            left="${left#"${left%%[![:space:]]*}"}"
            left="${left%"${left##*[![:space:]]}"}"

            right="${line#*:}"
            right="${right#"${right%%[![:space:]]*}"}"
            right="${right%"${right##*[![:space:]]}"}"
            inner_width=$(( (width - 12) / 2 ))

            printf "\e[38;5;183m │ \e[0m\e[1;38;5;121m%-*s\e[0m\e[38;5;183m │\e[0m  \e[38;5;183m│ \e[0m\e[1;38;5;111m%-*s\e[0m\e[38;5;183m │\e[0m\n" \
                "$inner_width" "$right" \
                "$inner_width" "$left"
        fi
    done
    print -P "%F{183} ╰${left_line}╯%f  %F{183}╰${right_line}╯%f"
}

# Startup