return {
	-- remote execution / loaders
	"require%s*%(%s*%d+%s*%)",
	"require",
	"getfenv",
	"loadstring",
	"pcall%s*%(%s*require",
	"string",
	"math",
	"luraph",
	"xen",
	"brew",

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

	-- hidden events
	"RemoteEvent",
	"BindableEvent",

	-- suspicious variables
	"a=",
	"b=",
	"local a=",

	-- keywords
	"backboor",
	"anti.backboor",
	"synapse",
	"exploit",
	"loading",
	"Joint",
}
