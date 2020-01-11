// content of index.js
const http = require('http')
const port = 80

const requestHandler = (request, response) => {
	console.log(request.url)
	response.end('Hello Node.js Server! -' + new Date().toISOString())
}

const server = http.createServer(requestHandler)

server.listen(port, (err) => {
	if (err) {
		return console.log('something bad happen', err)
	}
	
	console.log(`server is listening on ${port}`)
	})
