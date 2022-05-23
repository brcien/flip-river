const polka = require \polka
const fs = require \fs/promises
const yaml = require \js-yaml
const serve-static = require \serve-static
const {compile-file} = require \pug
const {join, normalize } = require \path
const {get-type} = require \mime/lite

const sanitize-path = -> normalize it .replace /^(\.\.(\/|\\|$))+/ ''
const here = -> join __dirname, sanitize-path it
const card-view = compile-file './views/card.pug'

const PORT = 8080
const index = compile-file \./views/index.pug

polka!
	..get \/ (req, res) ->>
		try
			const cards = await fs.readdir (here \cards/en_US/ ), \utf-8
			res.end index do
				cards: cards.map -> it.replace /.yml$/g ''
		catch e
			res.status-code = 500
			res.end ''+e
	..get \/cards/:card (req, res) ->>
		try
			const yml-file = await fs.read-file (here "cards/en_US/#{req.params.card}.yml"), \utf-8
			card = yaml.load yml-file
			card.printing = (card.printing || 'undefined').replace '~' card.name
			card.image = card.image || "/static/card-arts/#{req.params.card - /.yml$/}.png"
			const response = card-view card
			res.end response
		catch e
			res.status-code = 404
			res.end 'No such card'
	..use \/static serve-static here \static
	..listen PORT

console.log "Server running at http://localhost:#{PORT}/"