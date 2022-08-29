import express from 'express';
import 'dotenv/config';
import {fileURLToPath} from 'url';
import path from 'path';
import parseurl from 'parseurl';
import session from 'express-session';

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

// EXPRESS-SESSION mise en place
app.use(session({
    secret: "j'aime les chats bien cuits",
    // true permets de forcer la sauvegarder de la session même sans modification, évite de créer des conflit en cas de requête parallèle
    resave: true, // par default c'est save mais on le doit spécifier même si on veut la valeur à true
    // comme resave mais joue sur une nouvelle instance de la session 
    saveUninitialized: true, // par default c'est save mais on le doit spécifier même si on veut la valeur à true
    proxy: true,
    cookie: {
        maxAge: 24 * 60 * 60, // durée de vie de 1 journée -> 86 400 secondes
        secure: process.env.NOVE_ENV && process.env.NOVE_ENV === "production" ? true : false,
    },
}));

app.use((req, res, next)=>{
    // console.log("req.session ----->",req.session);
    res.locals.session = req.session;
    res.locals.error = null;
    
    if(!req.session.user){
        req.session.user = null;
        req.session.isLogged = false;
    }
    
    console.log("res.locals.session ---->",res.locals.session);
    next();
});


const adminIsLogged = false;
app.use((req,res,next)=>{
    // on affecte une nouvelle key à la propriété locals qui correspond à la valeur adminIsLogged et qu'on va pouvoir utiliser pour faire des vérifications coté (vue/view) dans le header par exemple
    res.locals.adminIsLogged = adminIsLogged;
    // et on passe à la fonctionnalité suivante avec next() qui est la fonction use pour vérifier l’accès aux urls
    next();
});

app.use((req,res, next)=>{
    // utilisation de la librairie parseurl, qui permets de mettre en cache et de fait avoir un rendement optimisé de notre application
    // à chaque instanciation on récupère l'url dans une variable pathname
    const pathname = parseurl(req).pathname;
    console.log(pathname)
    // on s'en sert pour vérifier que l'utilisateur est autorisé à acceder à certains lieu de notre app'
    // en l’occurrence, ici, on bloque l’accès à toutes pages qui contiennent le paramètre "/admin" SI l'admin n'est pas connecté, c'est le cas avec la simulation de la connexion avec la "const adminIsLogged = false;"
    if(pathname.includes("/admin") && !adminIsLogged) {
        res.redirect("/");
    } else {        
        next();
    }
});

// ROUTES
/*** HOME ***/
// get page (obtention de la page "/" (home) avec tous les articles(les posts/story))
app.get("/", async (req,res,next)=>{   
    const [posts] = await pool.execute(`SELECT post.Id AS postID, Title, Contents, CreationTimestamp, FirstName, LastName, Author_Id  FROM post JOIN author ON author.Id = post.Author_Id`);
    res.render("layout", {template: "pages/home", posts: posts});
});

/*** STORY ***/
// get page (obtention de la page "/story" (l'article sur lequel on a cliqué) avec ces commentaires associés)
app.get("/story/:id", async (req, res, next)=>{
    const [post] = await pool.execute(`SELECT Post.Id AS postID, Title, Contents, FirstName, LastName FROM post JOIN author ON author.Id = post.Author_Id`);

    const [comments] = await pool.execute(`SELECT NickName, Contents, CreationTimestamp FROM comment WHERE Post_Id = ? ORDER BY CreationTimestamp DESC`, [req.params.id]);

    res.render('layout', {template: "pages/story", post: post[0], comments: comments});
});

// post comment (envoi d'un commentaire dans la BDD)
app.post("/add_comment/:postID", async (req,res,next)=>{
    console.log(req.params.postID);
    // les données de l'input seront stockés dans la propriété body graçe à app.use(express.urlencoded({extended: true})); 
    console.log(req.body.alias); // --> stockera la value de l'input avec comme attribut name alias 
    console.log(req.body.comm);
    // requête d'insertion (POST) pour enregistrer les données du formulaire dans la bdd
    const [result] = await pool.execute(`INSERT INTO comment (NickName, Contents, CreationTimestamp, Post_Id) VALUES( ?, ?, NOW(), ?) `, [req.body.alias, req.body.comm, req.params.postID]);
    console.log(result);
    // quand la requête est terminée on redirige vers la page /detail/idDuPost et on retourne de fait sur la route get de la ligne 33
    res.redirect(`/pages/story/${req.params.postID}`);
});

// USER
// get entry page
app.get("/entry/:signup?", (req,res,next) =>{
    res.render("layout", {template: "pages/user/entry", typeform: !req.params.signup ? "signin" : "signup" });
});

// post register user
app.post("/entry/signup", (req,res,next)=>{
    const {alias, password} = req.body;
    req.session.user = {alias: alias, password: password};
    res.redirect("/entry");
    // pour le refacto, enregistrer l'user dans la bdd avec le mdp crypté
    // vérifié en amont que l'email n'existe pas déjà en bdd !!!
});

app.post("/entry/signin", (req,res,next)=>{
    const {alias, password} = req.body;
    if(alias === req.session?.user.alias && password === req.session?.user.password){
        req.session.isLogged = true;
        res.redirect("/");
    } else {
        res.locals.error = "bad alias/password";
        res.render("layout", {template: "pages/user/entry", typeform: !req.params.signup ? "signin" : "signup"})
    }
    // pour le refacto, en amont vérifier que l'adresse mail existe si non l'invité à créer un compte
    // si le mail existe il faut vérifier la correspondance entre les mdp
    // et on enregistre les données en session
});

// ADMIN
// get admin page (obtention de la page admin)
app.get("/admin", async (req,res,next)=>{
    const [stories] = await pool.execute(`SELECT post.Id AS postID, category.Name AS category_title, author.Id, Author_Id, Title, Contents, CreationTimestamp, FirstName, LastName FROM post JOIN author ON author.Id = post.Author_Id JOIN category ON category.Id = post.Category_Id`);

    res.render("layout", {template:"pages/admin/admin", stories:stories})
});

// get add story (obtention de la page avec le formulaire pour ajouter une story)
app.get("/admin/story/add", async(req,res,next)=>{
    const [categories] = await pool.execute(`SELECT Id, Name FROM category`);
    const [authors] = await pool.execute(`SELECT Id, FirstName, LastName FROM author`);

    res.render("layout", {template: "pages/admin/story/add", categories: categories, authors:authors});
});

// post add story envoi des données du formulaire dans la BDD
app.post("/admin/story/add", async (req,res,next)=>{
    try {
        console.log(req.body);
        const {title, story, author, category} = req.body;
        const [result] = await pool.execute(`INSERT INTO post (Title,Contents, CreationTimestamp, Author_Id, Category_Id) VALUES (?, ?, NOW(), ?, ?)`, [title, story, author, category]);

        if(result.affectedRows){
            res.redirect("/admin")
        }
    } catch (error) {
        console.log(error)
    }
});

// get edit page
app.get("/admin/story/edit/:postID", async (req,res,next)=>{
    const [story] = await pool.execute("SELECT post.Id AS postID, Title, Contents FROM post WHERE post.Id = ?", [req.params.postID]);    
    res.render("layout", {template: "pages/admin/story/edit", story: story[0]})
});

// post edit
app.post("/admin/story/edit/:postID",  async (req,res,next)=> {
    try {
        const {title, story} = req.body;
        const [result] = await pool.execute(`UPDATE post SET Title = ?, Contents = ? WHERE Id = ?`, [title, story, req.params.postID]);
        console.log(result);
        res.redirect("/admin");
    } catch (error) {
        console.log(error);
    }
});

// get delete story
app.get("/admin/story/delete/:postID", async (req,res,next)=>{
    try {
        const [result] = await pool.execute("DELETE FROM post WHERE Id = ? ", [req.params.postID]);
        console.log(result)
        res.redirect("/admin");
    } catch (error) {
        console.log(error)
    }
});

app.listen(PORT, ()=> {
    console.log(`Listening at http://localhost:${PORT}`)
});