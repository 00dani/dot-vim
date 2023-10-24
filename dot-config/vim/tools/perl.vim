vim9script

export def Lsp(module: string, args: list<string>): dict<any>
	const lsp = {
		name: module,
		filetype: 'perl',
		path: exepath('perl'),
		args: [$'-M{module}']->extend(args),
		install: $'cpanm {module}',
		installed: (): bool => HasModule(module),
	}
	return lsp
enddef

export def HasModule(module: string): bool
	# This can more reliably be tested by calling `perl -MModule::Name -E ''`
	# and checking the exit status, but simply looking for a matching file on
	# disk is much faster and works fine for my purposes.
	const libs = $PERL5LIB->split(';')
	const filename = module->substitute('::', '/', 'g') .. '.pm'
	for lib in libs
		if filereadable($'{lib}/{filename}')
			return true
		endif
	endfor
	return false
enddef
