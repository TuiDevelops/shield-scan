return {
	-- remote execution / loaders
	"require%s*%(%s*%d+%s*%)",
	"require",
	"getfenv",
	"loadstring",
	"pcall%s*%(%s*require",
	"pcall",
	"math",
	"luraph",
	"xen",
	"brew",
	"IsStudio",
	"eriuqer",
	":reverse()",

	-- game info
	"game.CreatorId",
	"game.PlaceId",

	-- HTTP / code download
	"HttpGet",
	"HttpPost",
	"syn%.request",

	-- asset insertion
	"InsertService",
	"GetObjects",
	"GetObject",

	-- suspicious loops
	"while%s+true%s+do",
	"repeat%s+wait",

	-- sites
	"github",
	"repo",
	"repository",
	"discord",

	-- hidden events
	"RemoteEvent",
	"BindableEvent",

	-- known modules
	"Yueliang",
	"Yue",
	"fiOne",
	"fione",

	-- suspicious variables
	"a=",
	"b=",
	"local a=",
	"lili",
	"local abc",

	-- keywords
	"backdoor",
	"anti.backdoor",
	"synapse",
	"exploit",
	"Joint",
	"webhook",
	"rotate",
	"dih",
}
