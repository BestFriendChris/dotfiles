packadd! copilot
let g:copilot_no_maps = v:true

function! s:CopilotSetup() abort
  imap <silent><nowait><expr> <Tab> copilot#Accept()
  imap <silent><nowait><expr> <C-]> copilot#Dismiss()

  imap <silent><nowait><expr> <D-]> copilot#Next()
  imap <silent><nowait><expr> <D-[> copilot#Previous()
  imap <silent><nowait><expr> <C-Space> copilot#Suggest()
endfunction

call bfc#plugins#on_load(funcref('<SID>CopilotSetup'))
