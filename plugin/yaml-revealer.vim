" Reveals the full tree structure of a Yaml key
" and allows to find a Yaml key
"
" Maintainer: Einenlum
" URL: https://github.com/Einenlum/yaml-revealer

function! GetIndentationStep()
    call cursor(1,1)
    call search('^\s')
    return indent(".")
endfunction

function! AddParentKeys()
    let goToLineCmd = ':' . s:inputLineNumber
    :exec goToLineCmd

    let l:parentIndent = s:currentIndent - s:indentationStep
    while l:parentIndent >= 0

        if l:parentIndent == 0
            :call search('^\S', 'b')
        else
            :call search('^\s\{'.l:parentIndent.'}\S', 'b')
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
    if &filetype != 'yaml'
        echo 'This is not a Yaml file.'
        return 0
    endif

    let s:inputLineNumber = a:inputLineNumber
    let currentLine = getline(s:inputLineNumber)
    let currentKey = matchstr(currentLine, '\s*\zs.\+\ze:')
    let s:keys = [currentKey]

    if !empty(currentLine)
        let s:indentationStep = GetIndentationStep()
        let s:currentIndent = indent(s:inputLineNumber)

        :call AddParentKeys()
        :call reverse(s:keys)
        echo join(s:keys, " > ")

        let goBackToLineCmd = ':'.s:inputLineNumber
        :exec goBackToLineCmd
    else
        echo "Empty line"
    endif
endfunction

function! KeyNotFound(keyName)
    echo "\n\"".a:keyName."\" not found."
    echo "\nThe correct syntax is:   firstVar>secondVar>thirdVar"
endfunction

function! SearchYamlKey()
    if &filetype != 'yaml'
        echo 'This is not a Yaml file.'
        return 0
    endif

    let userInput = input('Search for a Yaml key: ')
    let indentationStep = GetIndentationStep()

    " reset cursor
    call cursor(1,1)
    let inputList = split(userInput, '>')

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

nmap <Leader>yml :call GetTreeStructure(line("."))<CR>
nmap <Leader>ys :call SearchYamlKey()<CR>
