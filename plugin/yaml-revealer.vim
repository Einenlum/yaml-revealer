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

function! GetTreeStructure(inputLineNumber, separator)
    let initialView = winsaveview()
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

        :call winrestview(initialView)
        return join(s:keys, a:separator)
    else
        :call winrestview(initialView)
        return
    endif
endfunction

function! EchoTreeStructure(inputLineNumber, echoTreeStructureSeparator)
    let treeStructure = GetTreeStructure(a:inputLineNumber, a:echoTreeStructureSeparator)
    if !empty(treeStructure)
        echo treeStructure
    else
        echo "Empty line"
    endif
endfunction

function! FlatYaml()
    let initialView = winsaveview()
    let indentationStep = GetIndentationStep()
    let endLine = line("$")
    call cursor(1,1)
    
    let finalFile = []
    let currentLine = 1

    while currentLine < endLine
        let treeStructure = GetTreeStructure(currentLine, '')
        if !empty(treeStructure)
            let lineToDisplay = currentLine.': '.treeStructure
            :call add(finalFile, lineToDisplay)
        endif
        let currentLine += 1
    endwhile

    :call writefile(finalFile, $HOME.'/.vim/temp/temp.flatyml')
    sp ~/.vim/temp/temp.flatyml
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
    let userInput = input('Search for a Yaml key: ')
    let userInputList = split(userInput, '\zs')
    let finalSearch = ''

    for char in userInputList
        let finalSearch .= char.'\S*'
    endfor

    call cursor(1,1)
    call search(finalSearch)
    let searchCmd = 'call search(finalSearch)'
    exec searchCmd
    call cursor(".", 1)
    let matchLine = matchstr(getline("."), "\\d\\+")
    bw!
    exec ':'.matchLine
endfunction

nnoremap <Leader>yml :call EchoTreeStructure(line("."), " > ")<CR>
nnoremap <Leader>f :call FlatYaml()<CR>
