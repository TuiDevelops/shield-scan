return {
	HighRisk = {
		-- Dynamic code execution
		{
			pattern = "loadstring",
			display = "loadstring",
			score = 30,
			reason = "Dynamic code execution",
		},

		{
			pattern = "require%s*%(%s*%d+%s*%)",
			score = 45,
			reason = "External asset require",
		},

		{
			pattern = "require",
			score = 40,
			reason = "External asset require",
		},

		{
			pattern = "pcall%s*%(%s*require",
			score = 45,
			reason = "Protected external require",
		},

		-- Obfuscation
		{
			pattern = "eriuqer",
			display = "eriuqer",
			score = 35,
			reason = "Reversed require keyword",
		},

		{
			pattern = ":reverse%s*%(",
			display = ":reverse",
			score = 35,
			reason = "String reversal obfuscation",
		},

		{
			pattern = "luraph",
			display = "luraph",
			score = 60,
			reason = "Known obfuscator",
		},

		-- Embedded VM / custom execution
		{
			pattern = "fiOne",
			display = "fiOne",
			score = 60,
			reason = "Embedded Lua VM",
		},

		{
			pattern = "fione",
			display = "fione",
			score = 60,
			reason = "Embedded Lua VM",
		},

		{
			pattern = "Yueliang",
			display = "Yueliang",
			score = 60,
			reason = "Lua compiler implementation",
		},

		{
			pattern = "LuaX",
			display = "LuaX",
			score = 50,
			reason = "Lua compiler component",
		},

		{
			pattern = "LuaY",
			display = "LuaY",
			score = 50,
			reason = "Lua compiler component",
		},

		{
			pattern = "LuaZ",
			display = "LuaZ",
			score = 50,
			reason = "Lua compiler component",
		},

		{
			pattern = "LuaK",
			display = "LuaK",
			score = 50,
			reason = "Lua compiler component",
		},

		{
			pattern = "LuaP",
			display = "LuaP",
			score = 50,
			reason = "Lua compiler component",
		},
	},

	MediumRisk = {
		-- HTTP
		{
			pattern = "HttpGet",
			display = "HttpGet",
			score = 15,
			reason = "External web request",
		},

		{
			pattern = "HttpPost",
			display = "HttpPost",
			score = 20,
			reason = "External web request",
		},

		{
			pattern = "webhook",
			display = "webhook",
			score = 20,
			reason = "Webhook usage",
		},

		-- Asset loading
		{
			pattern = "InsertService",
			display = "InsertService",
			score = 20,
			reason = "Asset insertion",
		},

		{
			pattern = "GetObjects",
			display = "GetObjects",
			score = 20,
			reason = "Asset loading",
		},

		{
			pattern = "GetObject",
			display = "GetObject",
			score = 20,
			reason = "Asset loading",
		},

		{
			pattern = "MarketplaceService:GetProductInfo",
			display = "MarketplaceService:GetProductInfo",
			score = 20,
			reason = "External asset metadata",
		},

		-- Environment manipulation
		{
			pattern = "getfenv",
			display = "getfenv",
			score = 20,
			reason = "Environment access",
		},

		{
			pattern = "setfenv",
			display = "setfenv",
			score = 20,
			reason = "Environment modification",
		},

		-- Suspicious infinite loops
		{
			pattern = "while%s+true%s+do",
			display = "while true do",
			score = 15,
			reason = "Infinite loop",
		},

		{
			pattern = "repeat%s+wait",
			display = "repeat wait",
			score = 10,
			reason = "Persistent execution loop",
		},
	},

	LowRisk = {
		-- External services
		{
			pattern = "github",
			display = "github",
			score = 5,
			reason = "GitHub reference",
		},

		{
			pattern = "discord",
			display = "discord",
			score = 5,
			reason = "Discord reference",
		},

		-- Potential reconnaissance
		{
			pattern = "game%.CreatorId",
			display = "game%.CreatorId",
			score = 5,
			reason = "Creator information access",
		},

		{
			pattern = "game%.PlaceId",
			display = "game%.PlaceId",
			score = 5,
			reason = "Place information access",
		},

		{
			pattern = "IsStudio",
			display = "IsStudio",
			score = 5,
			reason = "Studio environment check",
		},
	},
}
