-- urTapperwareFile.lua
-- scaffolding for saving compositions to disk and load them back in utapperware
-- ==================================
-- = setup Global var and constants =
-- ==================================

CREATION_MARGIN = 40	-- margin for creating via tapping
INITSIZE = 140	-- initial size for regions
MENUHOLDWAIT = 0.5 -- seconds to wait for hold to menu

FADEINTIME = .2 -- seconds for things to fade in, TESTING for now
EPSILON = 0.001	--small number for rounding

-- selection param
LASSOSEPDISTANCE = 25 -- pixels between each point when drawing selection lasso

