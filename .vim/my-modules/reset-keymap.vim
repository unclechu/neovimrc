"native vim russian keyboard layout hacks
"resets keymap to english after leave insert mode
"Author: Viacheslav Lotsmanov

function! ResetKeyMap()
	set keymap=
	set keymap=russian-jcukenwin
	set iminsert=0
	set imsearch=-1
	let &langmap = 'йq,цw,уe,кr,еt,нy,гu,шi,щo,зp,х[,ъ],фa,ыs,вd,аf,пg,рh,оj'.
		\ ',лk,дl,э'',яz,чx,сc,мv,иb,тn,ьm,б\,,ю.,ё`,ЙQ,ЦW,УE,КR,ЕT,НY,ГU'.
		\ ',ШI,ЩO,ЗP,Х{,Ъ},ФA,ЫS,ВD,АF,ПG,РH,ОJ,ЛK,ДL,Э\",ЯZ,ЧX,СC,МV,ИB,ТN'.
		\ ',ЬM,Б\<,Ю\>,Ё\~'
endfunction
command ResetKeyMap call ResetKeyMap()

if has('autocmd')
	autocmd InsertEnter * call ResetKeyMap()
	autocmd InsertLeave * call ResetKeyMap()
endif

call ResetKeyMap()

"vim: set noet :
