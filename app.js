import express from 'express';
import 'dotenv/config';
import {fileURLToPath} from 'url';
import path from 'path';

import {PORT} from './lib/index.js';
import pool from './database/db.js';

const app = express();
// définition de l'emplacement de notre dossier contenant les vues(views)
app.set("views", "./views");
// définition du moteur de rendu --> ejs
app.set("view engine", "ejs");

// définition de la route static public
const __filename = fileURLToPath(import.meta.url);
const __dirname  = path.dirname(__filename);
app.use(express.static(path.join(__dirname + "/public")));

// middleware express natif qui permets de récupérer les données post afin de les parser
app.use(express.json()); // pour parser le content-type application/json
app.use(express.urlencoded({extended: true})); // pour parser les données formulaire post
// anciennement librairie body-parser qu'il fallait import en tant que module avant la version 4.x d'express

app.get("/", async (req,res,next)=>{
   
    const [posts] = await pool.execute(`SELECT post.Id AS postID, Title, Contents, CreationTimestamp, FirstName, LastName, Author_Id  FROM post JOIN author ON author.Id = post.Author_Id`);

    res.render("layout", {template: "home", posts: posts});

});

app.get("/detail/:id", async (req, res, next)=>{
    const [post] = await pool.execute(`SELECT Post.Id AS postID, Title, Contents, FirstName, LastName FROM post JOIN author ON author.Id = post.Author_Id`);

    const [comments] = await pool.execute(`SELECT NickName, Contents, CreationTimestamp FROM comment WHERE Post_Id = ? ORDER BY CreationTimestamp DESC`, [req.params.id]);

    res.render('layout', {template: "detail", post: post[0], comments: comments});
});

app.post("/add_comment/:postID", async (req,res,next)=>{
    console.log(req.params.postID);
    // les données de l'input seront stockés la propriété body
    console.log(req.body.alias); // --> stockera la value de l'input avec comme attribut name alias 
    console.log(req.body.comm);
    // requête d'insertion (POST) pour enregistrer les données du formulaire dans la bd
    const [result] = await pool.execute(`INSERT INTO comment (NickName, Contents, CreationTimestamp, Post_Id) VALUES( ?, ?, NOW(), ?) `, [req.body.alias, req.body.comm, req.params.postID]);
    console.log(result);
    // quand la requête est terminée on redirige vers la page /detail/idDuPost et on retourne de fait sur la route get de la ligne 33
    res.redirect(`/detail/${req.params.postID}`);
});

app.listen(PORT, ()=> {
    console.log(`Listening at http://localhost:${PORT}`)
});