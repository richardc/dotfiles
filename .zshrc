# .zshrc is sourced in interactive shells.  It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
# 	$Id: .zshrc,v 1.2 2000/04/24 20:05:32 richardc Exp $	

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
     NO_extended_glob \
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
CVSUMASK=002
PILOTRATE=38400
CVSROOT=':pserver:richardc@china.tw2.com:/home/cvs/repository'
PATH="/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/X11R6/bin:/usr/games"
IRCSERVER=irc.homelien.no


HISTFILE=~/.zshhistory
HISTSIZE=3000
SAVEHIST=3000

case $TERM in
xterm*)
	precmd () {
		print -Pn "\e]0;%n@%m:%~\a"
	}
	preexec () {
		print -Pn "\e]0;[$*] %n@%m:%~\a"
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

_compdir=/usr/share/zsh/functions
[[ -z $fpath[(r)$_compdir] ]] && fpath=($fpath $_compdir)
autoload -U compinit
compinit


# General completion technique
compstyle '*' completer _complete
compstyle ':incremental' completer _complete
compstyle ':predict' completer _complete
#compstyle '*' completer _complete _correct _approximate
#compstyle ':incremental' completer _complete _correct
#compstyle ':predict' completer _complete

# Cache functions created by _regex_arguments
compstyle '*' cache-path ~/.zsh-cache-path

# Expand partial paths
compstyle ':*' expand 'yes'
compstyle ':*' squeeze-slashes 'yes'

# Include non-hidden directories in globbed file completions
# for certain commands
compstyle '::complete:*' \
	tag-order 'globbed-files directories' all-files
compstyle '::complete:*:tar:directories' file-patterns '*~.*(-/)'

# Separate matches into groups
compstyle '*:matches' group 'yes'

# Describe each match group.
compstyle ':*:descriptions' format "%B---- %d%b"

# Messages/warnings format
compstyle ':*:messages' format '%B%U---- %d%u%b'
compstyle ':*:warnings' format '%B%U---- no match for: %d%u%b'

# Describe options in full
compstyle '*:options' description 'yes'
compstyle '*:options' auto-description '%d'

# Common hosts
: ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}}

hosts=(
    "$_etc_hosts[@]"

    localhost
)

compstyle '*' hosts $hosts

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
