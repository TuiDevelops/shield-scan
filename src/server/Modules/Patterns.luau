return {
	-- remote execution / loaders
	"require%s*%(%s*%d+%s*%)",
	"require",
	"getfenv",
	"loadstring",
	"pcall%s*%(%s*require",
	"pcall",
	"string",
	"math",
	"luraph",
	"xen",
	"brew",
	"IsStudio",

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

	-- suspicious loops
	"while%s+true%s+do",
	"repeat%s+wait",

	-- sites
	"github",
	"repo",
	"discord",

	-- hidden events
	"RemoteEvent",
	"BindableEvent",

	-- suspicious variables
	"a=",
	"b=",
	"local a=",
	"lili",
	"local abc",

	-- keywords
	"backboor",
	"anti.backboor",
	"synapse",
	"exploit",
	"loading",
	"Joint",
	"webhook",
	"rotate",
	"dih",
	"hi",
	"cool",
}
