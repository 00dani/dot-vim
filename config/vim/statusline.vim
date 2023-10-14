vim9script

import autoload ($XDG_CACHE_HOME .. '/vim/pack/minpac/start/vim-crystalline/autoload/crystalline.vim') as cr

def PrependIfVisible(status: string, prefix: string): string
	if empty(status)
		return ''
	endif
	return prefix .. status
enddef

def AppendIfVisible(status: string, affix: string): string
	if empty(status)
		return ''
	endif
	return status .. affix
enddef

def StatuslineSection(seps: number, group: string, components: list<string>): string
	const hiGroup = cr.ModeGroup(group)
	return components->copy()->filter((_, s) => s != '')
		->join(' ' .. cr.Sep(seps, hiGroup, hiGroup) .. ' ')
enddef

def GitStatus(): string
	if empty(g:FugitiveGitDir())
		return ''
	endif

	const branch = g:FugitiveHead()->PrependIfVisible("\ue0a0 ") # nf-pl-branch
	if !empty(branch)
		return branch
	endif

	return g:FugitiveHead(7)
		->PrependIfVisible("\Uf135e (") # nf-md-head
		->AppendIfVisible(")")
enddef

def StatuslineLeft(window: number, inactive: bool): string
	const bufnr = window->winbufnr()
	const b = bufnr->getbufvar('&')
	const fileName = [
		bufname(bufnr)->g:nerdfont#find()->AppendIfVisible(' '),
		b.buftype == '' ? '%t' : '%f',
		b.modifiable && b.modified ? cr.ModeHiItem('Modified') .. '+' .. cr.ModeHiItem('Fill') : '',
		b.readonly ? " \uf023" : '', # nf-fa-lock
	]->join('')
	if inactive
		return ' ' .. fileName
	endif

	const info = StatuslineSection(0, 'B', [
		GitStatus(),
		g:battery#component_escaped(),
	])->AppendIfVisible(' ' .. cr.Sep(0, cr.ModeGroup('B'), cr.ModeGroup('Fill')))
	const vimMode = cr.ModeSection(0, 'A', empty(info) ? 'Fill' : 'B')

	return join([vimMode, info, fileName])
enddef

def StatuslineRight(window: number, inactive: bool): string
	const percent = '%3p%%'
	const lineInfo = '%3l:%-2c'
	const fileType = '%{&ft}[%{&ff}]'
	if inactive
		return StatuslineSection(1, 'Fill', [fileType, percent, lineInfo])
	endif

	const fileEncoding = &fileencoding
	const fileInfo = StatuslineSection(1, 'Fill', [fileEncoding, fileType])

	const prettyPercent = cr.Sep(1, cr.ModeGroup('Fill'), cr.ModeGroup('B')) .. ' ' .. percent
	const prettyLineInfo = cr.Sep(1, cr.ModeGroup('B'), cr.ModeGroup('A')) .. lineInfo

	return join([fileInfo, prettyPercent, prettyLineInfo])
enddef

def ConfigurePlugins(): void
	g:battery#component_format = '%s %v%%'
	g:nerdfont#default = ''
	g:crystalline_theme = 'gruvbox8'
enddef

def InitStatus(): void
	def g:CrystallineStatuslineFn(window: number): string
		const inactive = window != winnr()
		const statusLeft = StatuslineLeft(window, inactive)
		const statusRight = StatuslineRight(window, inactive)

		return $'{statusLeft}%={statusRight}'
	enddef
enddef

def InitTab()
	g:crystalline_tab_mod = ''
	def g:CrystallineTablineFn(): string
		return cr.DefaultTabline({auto_prefix_groups: false})
	enddef

	def g:CrystallineTabFn(tabnr: number, bufnr: number, maxWidth: number, isSel: bool): list<any>
		var [tabDisplay, width] = cr.DefaultTab(tabnr, bufnr, maxWidth, isSel)

		if bufnr->getbufvar('&modified')
			const sel = isSel ? 'Sel' : ''
			tabDisplay ..= cr.HiItem($'Modified{sel}') .. '+' .. cr.HiItem($'Tab{sel}') .. ' '
			width += 2
		endif

		const icon = bufname(bufnr)->g:nerdfont#find()->PrependIfVisible(' ')
		if width + strchars(icon) >= maxWidth
			return [tabDisplay, width]
		endif

		return [icon .. tabDisplay, width + strchars(icon)]
	enddef
enddef

export def Init(): void
	InitStatus()
	InitTab()
	ConfigurePlugins()
	set noshowmode
enddef
