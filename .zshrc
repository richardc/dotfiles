# .zshrc is sourced in interactive shells.  It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.

zshrc_load_status () {
    echo -n "\r.zshrc load: $* ... \e[0K"
}

zshrc_load_status 'setting options'

setopt \
     NO_all_export \
        always_last_prompt \
     NO_always_to_end \
        append_history \
     NO_auto_cd \
        auto_list \
        auto_menu \
     NO_auto_name_dirs \
        auto_param_keys \
        auto_param_slash \
        auto_pushd \
        auto_remove_slash \
     NO_auto_resume \
        bad_pattern \
     NO_bang_hist \
        beep \
     NO_bg_nice \
     NO_brace_ccl \
     NO_bsd_echo \
        cdable_vars \
     NO_chase_links \
     NO_check_jobs \
     NO_clobber \
        complete_aliases \
     NO_complete_in_word \
     NO_correct \
     NO_correct_all \
     NO_csh_junkie_history \
     NO_csh_junkie_loops \
     NO_csh_junkie_quotes \
     NO_csh_null_glob \
        equals \
        extended_glob \
        extended_history \
        function_argzero \
        glob \
     NO_glob_assign \
        glob_complete \
     NO_glob_dots \
        glob_subst \
        hash_cmds \
        hash_dirs \
        hash_list_all \
        hist_allow_clobber \
        hist_beep \
	hist_expire_dups_first \
	hist_find_no_dups \
        hist_ignore_dups \
     NO_hist_ignore_space \
     NO_hist_no_store \
	hist_reduce_blanks \
     NO_hist_save_no_dups \
        hist_verify \
     NO_hup \
     NO_ignore_braces \
     NO_ignore_eof \
	inc_append_history \
        interactive_comments \
     NO_list_ambiguous \
     NO_list_beep \
        list_types \
        long_list_jobs \
        magic_equal_subst \
     NO_mail_warning \
     NO_mark_dirs \
     NO_menu_complete \
        multios \
        nomatch \
        notify \
     NO_null_glob \
        numeric_glob_sort \
     NO_overstrike \
     NO_path_dirs \
        posix_builtins \
        print_exit_value \
     NO_prompt_cr \
        prompt_subst \
        pushd_ignore_dups \
     NO_pushd_minus \
     NO_pushd_silent \
        pushd_to_home \
        rc_expand_param \
        rc_quotes \
     NO_rm_star_silent \
	share_history \
     NO_sh_file_expansion \
        sh_option_letters \
        short_loops \
     NO_sh_word_split \
     NO_single_line_zle \
     NO_sun_keyboard_hack \
     NO_unset \
     NO_verbose \
     NO_xtrace \
        zle

zshrc_load_status 'setting environment'

umask 002

PROMPT='%n@%m:%~%# '
export CVSUMASK=002
export CVS_RSH=ssh
export PILOTRATE=38400
export PATH="$HOME/bin:/sw/bin:/sw/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/X11R6/bin"
export LANG=C
export PAGER=less
export FRAMEBUFFER=/dev/fb0
export SYBASE=/usr/local/freetds
export QT_XFT=true

HISTFILE=~/.zshhistory
HISTSIZE=3000
SAVEHIST=3000

stty erase '^?' quit '^~'

case $TERM in
    xterm*)
	precmd () {
	    print -Pn "\e]0;%n@%m:%~\a"
	}
	preexec () {
	    print -Pn "\e]0;["
	    print -Rn "$1"
	    print -Pn "] %n@%m:%~\a"
	}
	;;
    screen*)
	precmd () {
	    print -Pn "\e]0;screen> %n@%m:%~\a"
	}
	preexec () {
	    print -Pn "\e]0;screen> ["
	    print -Rn "$1"
	    print -Pn "] %n@%m:%~\a"
	}
	;;
esac

if [[ -r ~/.zshrc.local ]]; then
	. ~/.zshrc.local
fi

if [[ -r ~/.zshrc.${HOST%%.*} ]]; then
	. ~/.zshrc.${HOST%%.*}
fi

zshrc_load_status 'completion system'

autoload -U compinit
compinit

zstyle ':completion:*' completer _complete _correct _approximate _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

zstyle ':completion:*' cache-path ~/.zsh/.cache-path

# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# Include non-hidden directories in globbed file completions
# for certain commands

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

# Messages/warnings format 
zstyle ':completion:*:messages' format '%B%U---- %d%u%b' 
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'

# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

# Common hosts
: ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}}

hosts=(
    "$_etc_hosts[@]"

    localhost
)

zstyle ':completion:*' hosts $hosts

zshrc_load_status 'aliases and functions'

#  Use this one to untar after doing a tar ztvf/tvf/ztf command
alias xt='fc -e - tvf=xf ztf=zxf -1'


zshrc_load_status 'key bindings'

bindkey -s '^X^Z' '%-^M'
bindkey '^[e' expand-cmd-path
bindkey -s '^X?' '\eb=\ef\C-x*'
bindkey '^[^I' reverse-menu-complete
bindkey '^X^N' accept-and-infer-next-history
bindkey '^[p' history-beginning-search-backward
bindkey '^[n' history-beginning-search-forward
bindkey '^[P' history-beginning-search-backward
bindkey '^[N' history-beginning-search-forward
bindkey '^W' kill-region
bindkey '^I' expand-or-complete-prefix
bindkey '^[b' emacs-backward-word
bindkey '^[f' emacs-forward-word

echo -n "\r"
