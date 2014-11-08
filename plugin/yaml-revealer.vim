" Reveals the full tree structure of a yaml key
"
" Maintainer: Einenlum
" URL: https://github.com/Einenlum/yaml-revealer

function! GetIndentationStep()
    call cursor(1,1)
    call search('^\s')
    return indent(".")
endfunction

function! AddParentsKeys()
    let goToLineCmd = ':' . s:inputLineNumber
    :exec goToLineCmd

    let l:parentIndent = s:currentIndent - s:indentationStep
    while l:parentIndent >= 0

        if l:parentIndent == 0
            :call search('^\S', 'b')
        else
            let searchCmd = ":call search('^\\s\\{" . l:parentIndent . "}\\S', 'b')"
            :exec searchCmd
        endif

        let parentKey = matchstr(getline("."), '\s*\zs.\+\ze:')
        :call add(s:keys, parentKey)
        let s:currentIndent = indent(".")
        if l:parentIndent >= 0
            let l:parentIndent = s:currentIndent - s:indentationStep
        endif
    endwhile
endfunction

function! GetTreeStructure(inputLineNumber)
    if &filetype == 'yaml'
        let s:inputLineNumber = a:inputLineNumber
        let currentLine = getline(s:inputLineNumber)
        let currentKey = matchstr(currentLine, '\s*\zs.\+\ze:')
        let s:keys = [currentKey]

        if !empty(currentLine)
            let s:indentationStep = GetIndentationStep()
            let s:currentIndent = indent(s:inputLineNumber)

            :call AddParentsKeys()
            :call reverse(s:keys)
            echo join(s:keys, " > ")

            let goBackToLineCmd = ':'.s:inputLineNumber
            :exec goBackToLineCmd
        endif
    endif
endfunction

nmap <Leader>yml :call GetTreeStructure(line("."))<CR>
