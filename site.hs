--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
module Main where

import  Data.Time.Format (defaultTimeLocale)
import  Data.Functor ((<$>))
import  Data.List (isPrefixOf)
import  Data.Monoid (mappend)
import  Data.Text (pack, unpack, replace, empty)
import  Hakyll

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    -- Compress CSS
    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    -- Copy fonts
    match "fonts/*" $ do
        route   idRoute
        compile copyFileCompiler

    -- Copy JS files
    match "js/*" $ do
        route   idRoute
        compile copyFileCompiler

    -- Copy design images
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    -- Copy project images
    match "images/projects/*" $ do
        route   idRoute
        compile copyFileCompiler

    -- Copy files
    match "files/*" $ do
        route   idRoute
        compile copyFileCompiler

    -- Render publications
    match "publications/*" $ do
        route   $ setExtension ".html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/publication.html" publicationCtx

            -- RSS feed
            >>= (externalizeUrls $ feedRoot feedConfiguration)
            >>= saveSnapshot "content"
            >>= (unExternalizeUrls $ feedRoot feedConfiguration)

            >>= loadAndApplyTemplate "templates/default.html" publicationCtx
            >>= relativizeUrls

    -- Render courses
    match "courses/*" $ do
        route   $ setExtension ".html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/course.html" courseCtx

            -- RSS feed
            >>= (externalizeUrls $ feedRoot feedConfiguration)
            >>= saveSnapshot "content"
            >>= (unExternalizeUrls $ feedRoot feedConfiguration)

            >>= loadAndApplyTemplate "templates/default.html" courseCtx
            >>= relativizeUrls

    -- Render publications list
    create ["publications.html"] $ do
        route idRoute
        compile $ do
            publications <- loadAll "publications/*"
            sorted <- recentFirst publications
            itemTpl <- loadBody "templates/publicationitem.html"
            list <- applyTemplateList itemTpl publicationCtx sorted
            makeItem list
                >>= loadAndApplyTemplate "templates/publications.html" allPublicationsCtx
                >>= loadAndApplyTemplate "templates/default.html"      allPublicationsCtx
                >>= relativizeUrls

    -- Render courses list
    create ["courses.html"] $ do
        route idRoute
        compile $ do
            courses <- loadAll "courses/*"
            sorted <- recentFirst courses
            itemTpl <- loadBody "templates/courseitem.html"
            list <- applyTemplateList itemTpl courseCtx sorted
            makeItem list
                >>= loadAndApplyTemplate "templates/courses.html" allCoursesCtx
                >>= loadAndApplyTemplate "templates/default.html" allCoursesCtx
                >>= relativizeUrls

    -- Render index
    create ["index.html"] $ do
        route idRoute
        compile $ do
            publications <- loadAll "publications/*"
            courses      <- loadAll "courses/*"
            sortedPublications <- take 5 <$> recentFirst publications
            sortedCourses      <- take 5 <$> recentFirst courses
            publicationItemTpl <- loadBody "templates/publicationitem.html"
            courseItemTpl      <- loadBody "templates/courseitem.html"
            listPublications <- applyTemplateList publicationItemTpl publicationCtx sortedPublications
            listCourses      <- applyTemplateList courseItemTpl      courseCtx      sortedCourses
            makeItem listPublications
            makeItem listCourses
                >>= loadAndApplyTemplate "templates/index.html"   (homeCtx listPublications listCourses)
                >>= loadAndApplyTemplate "templates/default.html" (homeCtx listPublications listCourses)
                >>= relativizeUrls

    -- Read templates
    match "templates/*" $ compile templateCompiler

--------------------------------------------------------------------------------
publicationCtx :: Context String
publicationCtx =
    dateFieldWith defaultTimeLocale "date" "%B %Y" `mappend`
    defaultContext

--------------------------------------------------------------------------------
courseCtx :: Context String
courseCtx =
    dateFieldWith defaultTimeLocale "date" "%Y" `mappend`
    defaultContext

--------------------------------------------------------------------------------
allPublicationsCtx :: Context String
allPublicationsCtx =
    constField "title" "Publications" `mappend`
    constField "description" "Publications list" `mappend`
    publicationCtx

--------------------------------------------------------------------------------
allCoursesCtx :: Context String
allCoursesCtx =
    constField "title" "Courses" `mappend`
    constField "description" "Courses list" `mappend`
    courseCtx

--------------------------------------------------------------------------------
homeCtx :: String -> String -> Context String
homeCtx listPublications listCourses =
    constField "publications" listPublications `mappend`
    constField "courses" listCourses `mappend`
    constField "title" "Home" `mappend`
    constField "description" "David Guyon's personal page" `mappend`
    defaultContext

--------------------------------------------------------------------------------
feedCtx :: Context String
feedCtx =
    bodyField "description" `mappend`
    publicationCtx

--------------------------------------------------------------------------------
feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle       = "David Guyon - Personal page"
    , feedDescription = "David Guyon's personal page"
    , feedAuthorName  = "David Guyon"
    , feedAuthorEmail = "david@guyon.me"
    , feedRoot        = "http://david.guyon.me"
    }

--------------------------------------------------------------------------------
externalizeUrls :: String -> Item String -> Compiler (Item String)
externalizeUrls root item = return $ fmap (externalizeUrlsWith root) item

externalizeUrlsWith :: String -- ^ Path to the site root
                    -> String -- ^ HTML to externalize
                    -> String -- ^ Resulting HTML
externalizeUrlsWith root = withUrls ext
  where
    ext x = if isExternal x then x else root ++ x

--------------------------------------------------------------------------------
unExternalizeUrls :: String -> Item String -> Compiler (Item String)
unExternalizeUrls root item = return $ fmap (unExternalizeUrlsWith root) item

unExternalizeUrlsWith :: String -- ^ Path to the site root
                      -> String -- ^ HTML to unExternalize
                      -> String -- ^ Resulting HTML
unExternalizeUrlsWith root = withUrls unExt
  where
    unExt x = if root `isPrefixOf` x then unpack $ replace (pack root) empty (pack x) else x

--------------------------------------------------------------------------------
