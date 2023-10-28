vim9script

# Convert multiple consecutive slashes // in the path to single slashes.
# Having extra slashes doesn't change the meaning of the path, but does make
# it uglier.
export def Normalise(path: string): string
	return path->substitute('//\+', '/', 'g')
enddef

# Express the given path relative to the directory provided as base. If the
# path is not located somewhere inside the base directory, the resulting path
# will start with one or more ../.
export def RelativeTo(path: string, base: string): string
	return ComputeRelativePath(
		path->fnamemodify(':p'),
		base->fnamemodify(':p'),
	)->Normalise()
enddef

def ComputeRelativePath(path: string, base: string): string
	# The given path points to a file *inside* the base, so we just need to drop the
	# prefix from the beginning of the path.
	if path->stridx(base) == 0
		return path[len(base) : -1]
	endif

	# the path leads to a file *outside*; let's move up in the hierarchy to find it
	return '../' .. path->ComputeRelativePath(base->fnamemodify(':h'))
enddef

defcompile
