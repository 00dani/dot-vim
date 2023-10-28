vim9script

# Convert a list of strings to a dictionary containing those same strings as
# keys, approximating a set type. You can use has_key() to test set membership
# on the result, rather than index().
export def ToStringSet(stringList: list<string>): dict<bool>
	var stringSet: dict<bool>
	for string in stringList
		stringSet[string] = true
	endfor
	return stringSet
enddef


# Returns the given status if it's not the same string as the provided
# 'default'. Otherwise returns an empty string.
export def DropIfDefault(status: string, default: string): string
	if status == default
		return ''
	endif
	return status
enddef

# Prepends the given prefix to the status, but only when the status is
# non-empty. Very useful for constructing a statusline with optional segments.
export def PrependIfVisible(status: string, prefix: string): string
	if empty(status)
		return ''
	endif
	return prefix .. status
enddef

# Appends the given affix to the status, but only when the status is
# non-empty. Quite similar to PrependIfVisible, and useful in the same sorts
# of situations.
export def AppendIfVisible(status: string, affix: string): string
	if empty(status)
		return ''
	endif
	return status .. affix
enddef

# Double-quotes a string, so it can safely be substituted into a Vim command
# with :execute or eval() and be interpreted as the same string.
export def Quote(str: string): string
	return '"' .. escape(str, '"\\') .. '"'
enddef

defcompile
