const express = require('express')
const app = express()
const port = 3000
const config = {
    host: 'db',
    user: 'root',
    password: 'root',
    database: 'nodedb'
}

const randomUser = 'User ' + Math.floor(Math.random() * 10000)

const mysql = require('mysql')
const connection = mysql.createConnection(config)
const sql = `INSERT INTO people(name) values ('${randomUser}')`
connection.query(sql)
connection.end()

app.get('/', (req, res) => {
    res.send('<h1>Hello</h1>')
})

app.listen(port, () => {
    console.log('Rodando na porta ' + port)
})