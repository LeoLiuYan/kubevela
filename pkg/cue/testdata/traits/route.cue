output: {
	apiVersion: "networking.k8s.io/v1beta1"
	kind:       "Ingress"
	spec: {
		rules: [{
			host: parameter.domain
			http: paths: [{
				backend: {
					serviceName: parameter.service
					servicePort: parameter.port
				}}]
		}]
	}
}
#route: {
	domain:  string
	port:    *80 | int
	service: string
}
parameter: #route
