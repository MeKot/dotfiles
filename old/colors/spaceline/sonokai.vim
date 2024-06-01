" =============================================================================
" Filename: spaceline.vim
" Author: glepnir
" URL: https://github.com/glepnir/spaceline.vim
" License: MIT License
" =============================================================================
function! spaceline#colorscheme#sonokai#sonokai()
  let s:slc={}
  let s:slc.yellow = ['fabd2f', 214]
  let s:slc.lightgray= ['c0c0c0', 188]
  let s:slc.purple = ['4e432f', 261]
  let s:slc.orange  = ['f08d71', 208]
  let s:slc.red = ['ec5f67', 203]
  let s:slc.blue = ['0087d7', 32]
  let s:slc.lightblue = ['6272a4', 225]
  let s:slc.teal = ['008080', 6]
  let s:slc.green = ['a6cd77', 148]
  let s:slc.darkgreen = ['394634', 148]
  let s:slc.gray = ['3c3836', 237]
  let s:slc.aqua= ['62b3b2',73]
  let s:slc.sonokai_bg= ['312c2b',16]

  call spaceline#colors#match_background_color(s:slc.sonokai_bg)

  let l:mode=mode()
  call spaceline#colors#spaceline_hl('HomeMode', s:slc, 'sonokai_bg', 'sonokai_bg')
  if empty(expand('%t'))
    call spaceline#colors#spaceline_hl('HomeModeRight',s:slc,  'sonokai_bg', 'sonokai_bg')
  else
    call spaceline#colors#spaceline_hl('HomeModeRight',s:slc,  'sonokai_bg', 'purple')
  endif

  call spaceline#colors#spaceline_hl('FileNameRight',s:slc, 'darkgreen','purple')
  call spaceline#colors#spaceline_hl('FileSizeRight',s:slc, 'darkgreen','purple')
  call spaceline#colors#spaceline_hl('GitLeft',s:slc,  'darkgreen',  'purple')
  call spaceline#colors#spaceline_hl('GitRight',s:slc,  'sonokai_bg',  'purple')
  call spaceline#colors#spaceline_hl('InActiveHomeRight', s:slc, 'yellow', 'sonokai_bg')
  call spaceline#colors#spaceline_hl('ShortRight', s:slc, 'yellow', 'sonokai_bg')

  call spaceline#colors#spaceline_hl('InActiveFilename', s:slc, 'lightgray', 'sonokai_bg')
  call spaceline#colors#spaceline_hl('FileName', s:slc, 'lightgray', 'purple','bold')
  call spaceline#colors#spaceline_hl('Filesize', s:slc, 'orange', 'darkgreen')
  call spaceline#colors#spaceline_hl('HeartSymbol', s:slc, 'orange',  'sonokai_bg')
  call spaceline#colors#spaceline_hl('CocError',s:slc,  'red',  'sonokai_bg')

  call spaceline#colors#spaceline_hl('CocWarn',s:slc,  'sonokai_bg',  'sonokai_bg')
  call spaceline#colors#spaceline_hl('GitBranchIcon',s:slc,  'lightgray',  'purple')
  call spaceline#colors#spaceline_hl('GitInfo',s:slc,  'lightgray',  'purple','bold')
  call spaceline#colors#spaceline_hl('GitAdd',s:slc,  'green',  'purple')
  call spaceline#colors#spaceline_hl('GitRemove',s:slc,  'red',  'purple')
  call spaceline#colors#spaceline_hl('GitModified',s:slc,  'orange',  'purple')

  call spaceline#colors#spaceline_hl('CocBar',s:slc,  'orange',  'sonokai_bg')
  call spaceline#colors#spaceline_hl('LineFormatRight',s:slc,  'sonokai_bg',  'sonokai_bg')

  call spaceline#colors#spaceline_hl('LineInfoLeft',s:slc,  'sonokai_bg',  'purple')
  call spaceline#colors#spaceline_hl('StatusEncod',s:slc,  'lightgray',  'purple')
  call spaceline#colors#spaceline_hl('StatusFileFormat',s:slc,  'lightgray',  'purple')

  call spaceline#colors#spaceline_hl('StatusLineinfo',s:slc,  'orange',  'sonokai_bg')
  call spaceline#colors#spaceline_hl('EndSeperate',s:slc,  'yellow',  'purple')
  call spaceline#colors#spaceline_hl('emptySeperate1',s:slc,  'sonokai_bg',  'sonokai_bg')
endfunction
