" Reveals the full tree structure of a Yaml key
" and allows to find a Yaml key
"
" Maintainer: Einenlum
" URL: https://github.com/Einenlum/yaml-revealer

" Global variables
let g:yaml_revealer_separator = get(g:, 'yaml_revealer_separator', ' > ')
let g:yaml_revealer_list_indicator = get(g:, 'yaml_revealer_list_indicator', 1)

function! GetIndentationStep()
  call cursor(1,1)
  call search('^\s')
  return indent(".")
endfunction

function! KeyNotFound(keyName)
    echo "\n\"".a:keyName."\" not found."
    echo "\nThe correct syntax is:   firstVar>secondVar>thirdVar"
endfunction

function! SearchYamlKey()
    let userInput = input('Search for a Yaml key: ')
    let indentationStep = GetIndentationStep()

    " reset cursor
    call cursor(1,1)
    let inputList = split(userInput, g:yaml_revealer_separator)

    " We look for the first match at 0, then at 2 or 4, and so on…
    " If not found at more that 10 the script stops
    let found = 0
    let indentationSearch = 0
    let loopCount = 0
    while !found
        let loopCount += 1
        if indentationSearch == 0
            let found = search('^'.inputList[0].':')
        else
            let found = search('^\s\{'.indentationSearch.'}'.inputList[0].':')
        endif
        let indentationSearch += indentationStep
        if loopCount > 10
            :call KeyNotFound(inputList[0])
            return 0
        endif
    endwhile

    " When we have found the first match
    " If there are other keys…
    if len(inputList) > 1
        let range = range(1, (len(inputList) - 1))
        for i in range
            let currentIndent = indent(".")
            let indentationSearch = currentIndent + indentationStep
            let found = search('^\s\{'.indentationSearch.'}'.inputList[i].':')
            if found == 0
                :call KeyNotFound(inputList[i])
                return 0
            endif
        endfor
    endif
endfunction

function! GetAncestors(line)
  if(indent(a:line) == 0 && a:line == 1)
    return ''
  endif

  if(indent(a:line) == 0 && a:line > 1)
    if(getline(a:line) !~ '^\s*$') " not an empty line
      return ''
    else
      " sometimes there are newlines within a multiline key
      return GetAncestors(a:line-1) " return ancestors of previous line
    endif
  endif

  let lowerIndent = indent(a:line)-1
  " check if line is part of a list
  let isList = ''
  if(getline(a:line) =~# '^\s*-')
    let isList = '[]'
    " find the first key above this in the file that has is not a list member
    let lastKeyLine = search('^\s\{0,'.indent(a:line).'}[^-]\S\+:', 'bnW')
  else
    " find the first key above this in the file that has a lower indent or a
    " containing list member
    let lastKeyLine = search('^\s\{0,'.lowerIndent.'}\(\S\+\|-\s\S\+\):', 'bnW')
    let lastKeyLineContent = getline(lastKeyLine)
    " check if the containing key is not a member of the same object
    if(lastKeyLineContent =~# ':\s.\+$' && lastKeyLineContent =~# '^\s*-')
      let lastKeyLine = search('^\s\{0,'.lowerIndent.'}\(\S\+\|-\s\S\+\):\s*$', 'zbnW')
      let isList = '[]'
    endif
  endif

  if(!g:yaml_revealer_list_indicator)
    let isList = ''
  endif

  let key = matchstr(getline(lastKeyLine), '\s*[\-]\?\s*\zs.\+\ze:').isList

  if(indent(lastKeyLine) > 0)
    return GetAncestors(lastKeyLine).g:yaml_revealer_separator.key
  endif

  return key
endfunction

augroup YamlRevealer
  au!
  if(&filetype =~# 'yaml')
    autocmd CursorMoved <buffer> redraw | echo GetAncestors(line('.'))
  endif
aug END
