--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
module Main where

import  Data.Time.Format (defaultTimeLocale)
import  Data.Functor ((<$>))
import  Data.List (isPrefixOf, group, groupBy)
import  Data.Monoid (mappend)
import  Data.Text (pack, unpack, replace, empty)
import  Text.Regex (Regex, mkRegex, matchRegex)
import  System.FilePath.Posix (takeBaseName)
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

    -- Render presentations
    match "presentations/*" $ do
        route   $ setExtension ".html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/presentation.html" presentationCtx

            -- RSS feed
            >>= (externalizeUrls $ feedRoot feedConfiguration)
            >>= saveSnapshot "content"
            >>= (unExternalizeUrls $ feedRoot feedConfiguration)

            >>= loadAndApplyTemplate "templates/default.html" presentationCtx
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

    -- Render projects
    match "projects/*" $ do
        route   $ setExtension ".html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/project.html" projectCtx

            -- RSS feed
            >>= (externalizeUrls $ feedRoot feedConfiguration)
            >>= saveSnapshot "content"
            >>= (unExternalizeUrls $ feedRoot feedConfiguration)

            >>= loadAndApplyTemplate "templates/default.html" projectCtx
            >>= relativizeUrls

    -- Render publications list
    create ["publications.html"] $ do
        route idRoute
        compile $ do
            publications <- fmap groupPublications $ recentFirst =<<
                                    loadAll "publications/*.md"

            let publicationsCtx =
                    listField "years"
                        (
                            field "year" (return . fst . itemBody) `mappend`
                            listFieldWith "publications" publicationCtx
                            (return . snd . itemBody)
                        )
                        (sequence $ fmap (\(y, is) -> makeItem (show y, is)) publications) `mappend`
                    constField "title" "Publications" `mappend`
                    constField "description" "Publications list" `mappend`
                    defaultContext

            --itemTpl <- loadBody "templates/publicationitem.html"
            --list <- applyTemplateList itemTpl publicationCtx sorted
            --makeItem list
            makeItem ""
                >>= loadAndApplyTemplate "templates/publications.html" publicationsCtx
                >>= loadAndApplyTemplate "templates/default.html"      publicationsCtx
                >>= relativizeUrls

    -- Render presentations list
    create ["presentations.html"] $ do
        route idRoute
        compile $ do
            presentations <- loadAll "presentations/*"
            sorted <- recentFirst presentations
            itemTpl <- loadBody "templates/presentationitem.html"
            list <- applyTemplateList itemTpl presentationCtx sorted
            makeItem list
                >>= loadAndApplyTemplate "templates/presentations.html" allPresentationsCtx
                >>= loadAndApplyTemplate "templates/default.html" allPresentationsCtx
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
            publications  <- loadAll "publications/*"
            presentations <- loadAll "presentations/*"
            courses       <- loadAll "courses/*"
            projects      <- loadAll "projects/*"
            sortedPublications  <- take 5 <$> recentFirst publications
            sortedPresentations <- take 5 <$> recentFirst presentations
            sortedCourses       <- take 5 <$> recentFirst courses
            sortedProjects      <- recentFirst projects
            publicationItemTpl  <- loadBody "templates/publicationitem.html"
            presentationItemTpl <- loadBody "templates/presentationitem.html"
            courseItemTpl       <- loadBody "templates/courseitem.html"
            projectItemTpl      <- loadBody "templates/projectitem.html"
            listPublications  <- applyTemplateList publicationItemTpl publicationCtx sortedPublications
            listPresentations <- applyTemplateList presentationItemTpl presentationCtx sortedPresentations
            listCourses       <- applyTemplateList courseItemTpl      courseCtx      sortedCourses
            listProjects      <- applyTemplateList projectItemTpl     projectCtx     sortedProjects
            makeItem listPublications
            makeItem listPresentations
            makeItem listCourses
            makeItem listProjects
                >>= loadAndApplyTemplate "templates/index.html"   (homeCtx listPublications listPresentations listCourses listProjects)
                >>= loadAndApplyTemplate "templates/default.html" (homeCtx listPublications listPresentations listCourses listProjects)
                >>= relativizeUrls

    -- Read templates
    match "templates/*" $ compile templateCompiler

--------------------------------------------------------------------------------
publicationCtx :: Context String
publicationCtx =
    dateFieldWith defaultTimeLocale "date" "%B %Y" `mappend`
    defaultContext

--------------------------------------------------------------------------------
presentationCtx :: Context String
presentationCtx =
    dateFieldWith defaultTimeLocale "date" "%B %Y" `mappend`
    defaultContext

--------------------------------------------------------------------------------
courseCtx :: Context String
courseCtx =
    dateFieldWith defaultTimeLocale "date" "%Y" `mappend`
    defaultContext

--------------------------------------------------------------------------------
projectCtx :: Context String
projectCtx =
    defaultContext

--------------------------------------------------------------------------------
allPublicationsCtx :: Context String
allPublicationsCtx =
    constField "title" "Publications" `mappend`
    constField "description" "Publications list" `mappend`
    publicationCtx

--------------------------------------------------------------------------------
allPresentationsCtx :: Context String
allPresentationsCtx =
    constField "title" "Presentations" `mappend`
    constField "description" "Presentations list" `mappend`
    publicationCtx

--------------------------------------------------------------------------------
allCoursesCtx :: Context String
allCoursesCtx =
    constField "title" "Courses" `mappend`
    constField "description" "Courses list" `mappend`
    courseCtx

--------------------------------------------------------------------------------
homeCtx :: String -> String -> String -> String -> Context String
homeCtx listPublications listPresentations listCourses listProjects =
    constField "publications" listPublications `mappend`
    constField "presentations" listPresentations `mappend`
    constField "courses" listCourses `mappend`
    constField "projects" listProjects `mappend`
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
-- Groups article items by year (reverse order).
groupPublications :: [Item String] -> [(Int, [Item String])]
groupPublications = fmap merge . group . fmap tupelise
    where
       merge :: [(Int, [Item String])] -> (Int, [Item String])
       merge gs   = let conv (year, acc) (_, toAcc) = (year, toAcc ++ acc)
                    in  foldr conv (head gs) (tail gs)

       group ts   = groupBy (\(y, _) (y', _) -> y == y') ts
       tupelise i = let path = (toFilePath . itemIdentifier) i
                    in  case (publicationYear . takeBaseName) path of
                            Just year -> (year, [i])
                            Nothing   -> error $
                                            "[ERROR] wrong format: " ++ path
-- Extracts year from article file name.
publicationYear :: FilePath -> Maybe Int
publicationYear s = fmap read $ fmap head $ matchRegex publicationRx s

publicationRx :: Regex
publicationRx = mkRegex "^([0-9]{4})\\-([0-9]{2})\\-([0-9]{2})\\-(.+)$"
