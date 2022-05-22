const polka = require \polka
const fs = require \fs/promises
const {join} = require \path
const yaml = require \js-yaml

const here = join __dirname, _

polka!
	..get \/cards/:card (req, res) ->>
		try
			const yml-file = await fs.read-file (here "cards/#{req.params.card}.yml"), \utf-8
			const card = yaml.load yml-file
			res.end card.hello
		catch e
			res.status-code = 404
			res.end 'No such card'
			console.log e
	..listen 8080
