#Personal web page powered by Hakyll
Hereby I present the web project behind my [personal page](https://david.guyon.me).
I uses the Haskell programing language with the Hakyll package.

##Software setup and build instructions
I'm running on Archlinux and use the ``stack`` tool to manage everything (``pacman -S stack``). In the project directory, ``stack init`` initialize the compilation based on _site.cabal_. Then, run ``stack build`` to execute the compilation. If you have an error for a missing module (eg. Data.Time.Format), search this module on [this website](https://www.stackage.org/). You'll find the package including this module. Add the package to the _build-depends_ list in _site.cabal_. 
To only compile small changes, you can execute ``stack exec site build`` or with ``rebuild`` if it's not the first time. Finally, to access the preview server, run ``stack exec site watch``.

For a full list of instructions, here's the [documentation](https://jaspervdj.be/hakyll/tutorials.html).

##Last important updates
###07/03/18
- moving to the ``stack`` tool

###23/09/16
- New course: CSR 2016
- New project: Feu de Camp

###01/06/16
- E3-RSD presentation

###30/03/16
- Presentation feature in the global project
- GreenCom15 presentation
- Grid'5000 winter school 16 presentation

###18/03/16
- Add conference attribute on publications

###03/06/15
- Publications page
- 2 entries in the publications page

###01/10/14
- Complete new design
- New version of the English CV
- New version of the French CV

###26/07/14
- Add new project in the list: Dynamic lstopo
- Convert all indent to spaces
- Fix the shadow bug when hover the boxes

###07/12/13
- CV updated

###28/10/13
- Add a link in the Pie-Boat project tile

###11/09/13
- Add new project in the list: Bomberman
- Better JS to show/hide the list

###12/07/13
- Section "Where" updated

###07/07/13
- Add new project in the list: ENU Taxis

###05/06/13
- JS handles language switching
- Add a Favicon
- new font: Droid from Google

###12/05/13
- Creative Commons licence created
- Page completly in English
- French version available

###30/03/13
- header finished
- "Where am I?" block is add and finished
- "My Website" bock is add and finished
- "My Blog" block is add and finished
- "My Projects" block is add and finished
- A click on "My Projects" block displays the projects list
- A second click hides this list

###11/03/13
- header almost finished
- I added the first block : "Who am I?"
