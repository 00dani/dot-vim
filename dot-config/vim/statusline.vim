vim9script

import autoload ($XDG_CACHE_HOME .. '/vim/pack/minpac/start/vim-crystalline/autoload/crystalline.vim') as cr
import './tools/paths.vim'
import './tools/strings.vim' as st

def StatuslineSection(seps: number, group: string, components: list<string>): string
	const hiGroup = cr.ModeGroup(group)
	return components->copy()->filter((_, s) => s != '')
		->join(' ' .. cr.Sep(seps, hiGroup, hiGroup) .. ' ')
enddef

def GitStatus(gitDir: string): string
	if empty(gitDir)
		return ''
	endif

	const branch = g:FugitiveHead(gitDir)->st.PrependIfVisible("\ue725 ") # nf-dev-git_branch
	if !empty(branch)
		return branch
	endif

	return g:FugitiveHead(7, gitDir)
		->st.PrependIfVisible("\ue729 (") # nf-dev-git_commit
		->st.AppendIfVisible(")")
enddef

def StatuslineLeft(window: number, inactive: bool): string
	const bufnr = window->winbufnr()
	const filePath = bufname(bufnr)
	const gitDir = g:FugitiveGitDir(bufnr)

	const friendlyPath = empty(gitDir) ? filePath->fnamemodify(':~') : filePath->paths.RelativeTo(gitDir->fnamemodify(':h'))
	const b = bufnr->getbufvar('&')

	const fileName = [
		g:nerdfont#find(filePath)->st.DropIfDefault(g:nerdfont#default)->st.AppendIfVisible(' '),
		b.buftype == '' ? friendlyPath : '%f',
		b.modifiable && b.modified ? cr.ModeHiItem('Modified') .. '+' .. cr.ModeHiItem('Fill') : '',
		b.readonly ? " \uf023" : '', # nf-fa-lock
	]->join('')
	if inactive
		return ' ' .. fileName
	endif

	const info = StatuslineSection(0, 'B', [
		GitStatus(gitDir),
		g:battery#component_escaped(),
	])->st.AppendIfVisible(' ' .. cr.Sep(0, cr.ModeGroup('B'), cr.ModeGroup('Fill')))
	const vimMode = cr.ModeSection(0, 'A', empty(info) ? 'Fill' : 'B')

	return join([vimMode, info, fileName])
enddef

def StatuslineRight(window: number, inactive: bool): string
	const percent = '%3p%%'
	const lineInfo = '%3l:%-2c'
	const fileType = '%{&ft}[%{&ff}]'
	if inactive
		return StatuslineSection(1, 'Fill', [fileType, percent, lineInfo])
	endif

	const fileEncoding = &fileencoding
	const fileInfo = StatuslineSection(1, 'Fill', [fileEncoding, fileType])

	const prettyPercent = cr.Sep(1, cr.ModeGroup('Fill'), cr.ModeGroup('B')) .. ' ' .. percent
	const prettyLineInfo = cr.Sep(1, cr.ModeGroup('B'), cr.ModeGroup('A')) .. ' ' .. lineInfo

	return join([fileInfo, prettyPercent, prettyLineInfo])
enddef

def ConfigurePlugins(): void
	g:battery#component_format = '%s %v%%'
	g:nerdfont#autofix_cellwidths = 0
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

		const icon = bufname(bufnr)->g:nerdfont#find()->st.DropIfDefault(g:nerdfont#default)->st.PrependIfVisible(' ')
		const iconWidth = strwidth(icon)
		if width + iconWidth >= maxWidth
			return [tabDisplay, width]
		endif

		return [icon .. tabDisplay, width + iconWidth]
	enddef
enddef

export def Init(): void
	InitStatus()
	InitTab()
	ConfigurePlugins()
	set noshowmode
enddef
