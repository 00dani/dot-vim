vim9script

const dark = {
	bg0: ['#282828', 235],
	bg1: ['#3c3836', 237],
	bg2: ['#504945', 239],
	bg4: ['#7c6f64', 243],

	fg1: ['#ebdbb2', 187],
	fg4: ['#a89984', 137],

	green: ['#98971a', 100],
	yellow: ['#d79921', 172],
	blue: ['#458588', 66],
	aqua: ['#689d6a', 71],
	orange: ['#d65d0e', 166],
	red: ['#fb4934', 203],
}

const light = {
	bg0: ['#fbf1c7', 230],
	bg1: ['#ebdbb2', 187],
	bg2: ['#d5c4a1', 187],
	bg4: ['#a89984', 137],

	fg1: ['#3c3836', 237],
	fg4: ['#7c6f64', 243],

	green: ['#98971a', 100],
	yellow: ['#d79921', 172],
	blue: ['#458588', 66],
	aqua: ['#689d6a', 71],
	orange: ['#d65d0e', 166],
	red: ['#9d0006', 124],
}

def ToCrystalline(fg: list<any>, bg: list<any>): list<any>
	return [
		[fg[1], bg[1]],
		[fg[0], bg[0]],
		''
	]
enddef

def MakeTheme(c: dict<list<any>>): dict<list<any>>
	var theme = {
		A: ToCrystalline(c.bg0, c.bg4),
		B: ToCrystalline(c.fg4, c.bg2),
		Fill: ToCrystalline(c.fg4, c.bg1),

		InactiveA: ToCrystalline(c.bg4, c.bg1),
		InactiveB: ToCrystalline(c.bg4, c.bg1),
		InactiveFill: ToCrystalline(c.bg4, c.bg1),

		InsertModeA: ToCrystalline(c.bg0, c.blue),
		InsertModeFill: ToCrystalline(c.fg4, c.bg2),

		VisualModeA: ToCrystalline(c.bg0, c.orange),
		ReplaceModeA: ToCrystalline(c.bg0, c.aqua),
		ReplaceModeFill: ToCrystalline(c.fg4, c.bg2),
		TerminalModeA: ToCrystalline(c.bg0, c.green),

		Modified: ToCrystalline(c.red, c.bg1),
		InsertModeModified: ToCrystalline(c.red, c.bg2),

		TabSel: ToCrystalline(c.bg0, c.fg4),
		ModifiedSel: ToCrystalline(c.bg1, c.fg4),
	}

	theme->extend({
		Tab: theme.Fill,
		NormalModeModified: theme.Modified,
		CommandModeModified: theme.Modified,
		VisualModeModified: theme.Modified,
		ReplaceModeModified: theme.InsertModeModified,
	})

	return theme
enddef

export def GetThemeColours(): dict<list<any>>
	return &background ==# 'dark' ? dark : light
enddef

export def SetTheme(): void
	GetThemeColours()->MakeTheme()->g:crystalline#GenerateTheme()
enddef
