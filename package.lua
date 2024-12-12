return {
	name = 'MrEntrasil/Discordis',
	version = '0.0.5',
	homepage = 'https://github.com/discordis-lua/discordis',
	dependencies = {
		'creationix/coro-http@3.1.0',
		'creationix/coro-websocket@3.1.0',
		'luvit/secure-socket@1.2.2'
	},
	tags = {'discord', 'api', 'wrapper', 'discord wrapper'},
	license = 'MIT',
	author = 'MrEntrasil',
	files = {'src/**.lua'},
}