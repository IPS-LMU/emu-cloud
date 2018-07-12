export const appConfig = {
	enableLoginForm: false,
	openIdConnect: {
		enabled: true,
		providerUrl: 'http://example.com:8080/auth/realms/master/',
		clientId: 'emudb-manager'
	},
	urls: {
		emuWebApp: 'https://ips-lmu.github.io/EMU-webApp/',
		externalLoginApp: '',
		managerAPIBackend: 'http://example.com:8000/emudb-manager.php',
		nodeJSServer: 'ws://example.com:17890'
	}
};
