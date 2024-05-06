#!/bin/env zsh

set -e

function pretty_git_log {
  # Check for the existence of certain git log arguments
  local using_graph=false
  local arg_i
  for arg_i in "$@"; do
    if [ "$arg_i" = "--graph" ]; then
      using_graph=true
    fi
    if [ "$arg_i" = "--oneline" ]; then
      git log $@
      return $?
    fi
  done

  local N_HASH_CHARS=$(git log --pretty=format:%h -1 | tr -d '\n' | wc -c | tr -d '[:space:]')
  if [ "$using_graph" = true ]; then
    local scrn_sz_arr=( $(stty size) )  #stty not tput in case of missing TERMINFO
    local N_SCRN_COLS=${scrn_sz_arr[1]}
    local N_GRPH_MAX_CHARS=$(expr $N_SCRN_COLS / 5) #Use no more then 20% of screen
    local N_GRPH_ACT_CHARS=$(
      git log --graph --pretty=format:"%<(1,trunc)%ad" |
      tr -d '..' |
      awk '{print length}' |
      sort -nr |
      head -1 |
      tr -d '[:space:]'
    )
    if [ "$N_GRPH_ACT_CHARS" -lt "$N_GRPH_MAX_CHARS" ]; then
      local N_GRPH_RSRV_CHARS=$N_GRPH_ACT_CHARS
    else
      local N_GRPH_RSRV_CHARS=$N_GRPH_MAX_CHARS
    fi
    #Extend space of N_HASH_CHARS to keep alignment when --graph option used.
    N_HASH_CHARS=$(expr $N_HASH_CHARS + $N_GRPH_RSRV_CHARS)
  fi

  local N_AUTH_DATE_CHARS=5
  local N_AUTH_NAME_CHARS=$(git log --pretty=format:"%aN" | awk '{print length}' | sort -nr | head -1 | tr -d '[:space;]')

  local N_MSG_INDENT_CHARS=$(expr $N_HASH_CHARS + 1 + $N_AUTH_DATE_CHARS + $N_AUTH_NAME_CHARS + 1)
  local N_STAT_INDENT_CHARS=$(expr $N_MSG_INDENT_CHARS + 5)

  HASH="%C(yellow)%>|($N_HASH_CHARS)%h%Creset"
  RELATIVE_TIME="%Cgreen(%ar)%Creset"
  AUTHOR="%C(bold blue)<%<($N_AUTH_NAME_CHARS,trunc)%aN>%Creset"
  SUBJECT="%s"
  REFS="%C(red)%d%Creset"
  git log \
    --date=short \
    --color \
    --pretty=tformat:"$HASH $RELATIVE_TIME $AUTHOR $SUBJECT $REFS" \
    $* |
    expand -t 1 |
     # Remove git-branchless refs
    gsed -E \
        -e 's_(, )?refs/branchless/[a-f0-9]*( ,)?__g' \
        -e 's/ \(\)//' |
     # Remove tags and origin refs
    gsed -E \
        -e 's_tag: [^, )]*(, )?__g' \
        -e 's_origin/[^, )]+(, )?__g' \
        -e 's/,\s*\)/)/' \
        -e 's/\(\s*,/(/' \
        -e 's/ \(\)//' |
    # Replace (2 years, 3 months ago) with (2y)
    gsed -E \
      -e 's/(^[^<]*) ago\)/\1)/' \
      -e 's/(^[^<]*), [[:digit:]]+ .*months?\)/\1)/' \
      -e 's/ seconds?\)/s)/' \
      -e 's/ minutes?\)/m)/' \
      -e 's/ hours?\)/h)/' \
      -e 's/ days?\)/d)/' \
      -e 's/ weeks?\)/w)/' \
      -e 's/ months?\)/M)/' \
      -e 's/ years?\)/y)/' \
      -e 's/\(([0-9]*)(.)\)/(\t\1\2\t)/' |

    awk 'BEGIN { FS="\t" } { printf "%s%3s%s\n", $1, $2, $3 }' |

    gsed -E $'/.*[*]/!{/.*[|]{1}/s/\x1b\\[([0-9](;[0-9])*)*[mGK]([_])\x1b\\[([0-9](;[0-9])*)*[mGK]/_/g;}' |
    gsed -E $'/.*[*]/!{/.*[|]{1}/s/\x1b\\[([0-9](;[0-9])*)*[mGK]([|])\x1b\\[([0-9](;[0-9])*)*[mGK]/|/g;}' |
    gsed -E $'/.*[*]/!{/.*[|]{1}/s/\x1b\\[([0-9](;[0-9])*)*[mGK]([\\])\x1b\\[([0-9](;[0-9])*)*[mGK]/\\\/g;}' |
    gsed -E $'/.*[*]/!{/.*[|]{1}/s/\x1b\\[([0-9](;[0-9])*)*[mGK]([\/])\x1b\\[([0-9](;[0-9])*)*[mGK]/\//g;}' |
    gsed -E "/^[|[:space:]]+[^[:alnum:]\\\/]+$/s/[|]//g" |
    gsed -E "s/^([[:space:]_|\\\/]{0,$N_HASH_CHARS})([A-Z][[:space:]])/\1$(printf -- '\t')\2/" |
    gsed -E "s/^([[:space:]_|\\\/]{0,$N_HASH_CHARS})([R][0-9][0-9][0-9][[:space:]])/\1$(printf -- '\t')\2/" |
    gsed -E "s/^([[:space:]_|\\\/]{0,$N_HASH_CHARS})([C][0-9][0-9][[:space:]])/\1$(printf -- '\t')\2/" |
    gsed -E "s/^([[:space:]_|\\\/]{0,$N_HASH_CHARS})([.a-zA-Z0-9]{2,}.*)/\1$(printf -- '\t')\2/" |
    awk 'BEGIN{ FS="\t" }{ printf "%-'$N_STAT_INDENT_CHARS's%s\n", $1, $2 }' |
    tr -d '\t' |
    sed -E 's/[[:space:]]*$//' |
    awk NF |
    less -FXR --chop-long-lines -E
}
