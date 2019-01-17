#Personal web page powered by Hakyll
Hereby I present the web project behind my [personal page](https://david.guyon.me).
I uses the Haskell programing language with the Hakyll package.

##Software setup and build instructions
I'm running on Archlinux and use the ``stack`` tool to manage everything (``pacman -S stack``). In the project directory, ``stack init`` initialize the compilation based on _site.cabal_. Then, run ``stack build`` to execute the compilation. If you have an error for a missing module (eg. Data.Time.Format), search this module on [this website](https://www.stackage.org/). You'll find the package including this module. Add the package to the _build-depends_ list in _site.cabal_. 
To only compile small changes, you can execute ``stack exec site build`` or with ``rebuild`` if it's not the first time. Finally, to access the preview server, run ``stack exec site watch``.

For a full list of instructions, here's the [documentation](https://jaspervdj.be/hakyll/tutorials.html).

